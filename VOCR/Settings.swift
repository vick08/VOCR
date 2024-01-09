//
//  Settings.swift
//  VOCR
//
//  Created by Chi Kim on 10/14/19.
//  Copyright © 2019 Chi Kim. All rights reserved.
//

import Cocoa
import AudioKit

enum Settings {
	
	static private var eventMonitor: Any?
	static var positionReset = true
	static var positionalAudio = false
	static var moveMouse = true
	static var launchOnBoot = true
	static var autoScan = false
	static var targetWindow = false
	static var GPTAPIKEY = ""
	static var mode = "OCR"
	
	static var allSettings: [(title: String, action: Selector, value: Bool)] {
		return [
			("Target Window", #selector(MenuHandler.toggleSetting(_:)), targetWindow),
			("Auto Scan", #selector(MenuHandler.toggleAutoScan(_:)), autoScan),
			("Reset Position on Scan", #selector(MenuHandler.toggleSetting(_:)), positionReset),
			("Positional Audio", #selector(MenuHandler.toggleSetting(_:)), positionalAudio),
			("Move Mouse", #selector(MenuHandler.toggleSetting(_:)), moveMouse),
			("Launch on Login", #selector(MenuHandler.toggleLaunch(_:)), launchOnBoot)
		]
	}
	
	static func setupMenu(target: AnyObject) -> NSMenu {
		load()
		let menu = NSMenu()
		
		for setting in allSettings {
			let menuItem = NSMenuItem(title: setting.title, action: setting.action, keyEquivalent: "")
			menuItem.target = target
			menuItem.state = setting.value ? .on : .off
			menu.addItem(menuItem)
		}
		
		if Settings.autoScan {
			installMouseMonitor()
		}
			
		let soundOutputMenuItem = NSMenuItem(title: "Sound Output...", action: #selector(target.chooseOutput(_:)), keyEquivalent: "")
		soundOutputMenuItem.target = target
		menu.addItem(soundOutputMenuItem)
		
		let enterAPIKeyMenuItem = NSMenuItem(title: "OpenAI API Key...", action: #selector(target.presentApiKeyInputDialog(_:)), keyEquivalent: "")
		enterAPIKeyMenuItem.target = target
		menu.addItem(enterAPIKeyMenuItem)

		let saveMenuItem = NSMenuItem(title: "Save OCR Result...", action: #selector(target.saveResult(_:)), keyEquivalent: "")
		saveMenuItem.target = target
		menu.addItem(saveMenuItem)

		let aboutMenuItem = NSMenuItem(title: "About...", action: #selector(target.displayAboutWindow(_:)), keyEquivalent: "")
		aboutMenuItem.target = target
		menu.addItem(aboutMenuItem)
		
		menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
		return menu
	}
	static func installMouseMonitor() {
		self.eventMonitor = NSEvent.addGlobalMonitorForEvents(
			matching: [NSEvent.EventTypeMask.leftMouseDown],
			handler: { (event: NSEvent) in
				switch event.type {
				case .leftMouseDown:
					print("Left mouse click detected.")
					if Navigation.shared.navigationShortcuts != nil {
						Thread.sleep(forTimeInterval: 0.5)
						Navigation.shared.prepare(mode:"OCR")
					}
				case .rightMouseDown:
					print("Right mouse click detected.")
					if Navigation.shared.navigationShortcuts != nil {
						Thread.sleep(forTimeInterval: 0.5)
						Navigation.shared.prepare(mode: "OCR")
					}
				default:
					break
				}
			})
	}
	
	static func removeMouseMonitor() {
		if let eventMonitor = self.eventMonitor {
			NSEvent.removeMonitor(eventMonitor)
		}
	}
	
	static func displayApiKeyDialog() {
		let alert = NSAlert()
		alert.messageText = "OpenAI API Key"
		alert.informativeText = "Type your OpenAI API key below:"
		alert.addButton(withTitle: "Save")
		alert.addButton(withTitle: "Cancel")
		let inputTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
		inputTextField.placeholderString = "API Key"
		inputTextField.stringValue = Settings.GPTAPIKEY
		alert.accessoryView = inputTextField
		let response = alert.runModal()
		if response == .alertFirstButtonReturn { // OK button
			let apiKey = inputTextField.stringValue
			Settings.GPTAPIKEY = apiKey
			Settings.save()
		}
	}
	
	
	static func load() {
		let defaults = UserDefaults.standard
		Settings.positionReset = defaults.bool(forKey:"positionReset")
		Settings.positionalAudio = defaults.bool(forKey:"positionalAudio")
		Settings.launchOnBoot = defaults.bool(forKey:"launchOnBoot")
		Settings.autoScan = defaults.bool(forKey:"autoScan")
		Settings.targetWindow = defaults.bool(forKey:"targetWindow")
		if let apikey = defaults.string(forKey: "GPTAPIKEY") {
			Settings.GPTAPIKEY = apikey
		}
		if let mode = defaults.string(forKey: "mode") {
			Settings.mode = mode
		}
		
	}
	
	static func save() {
		let defaults = UserDefaults.standard
		defaults.set(Settings.positionReset, forKey:"positionReset")
		defaults.set(Settings.positionalAudio, forKey:"positionalAudio")
		defaults.set(Settings.launchOnBoot, forKey:"launchOnBoot")
		defaults.set(Settings.autoScan, forKey:"autoScan")
		defaults.set(Settings.targetWindow, forKey:"targetWindow")
		defaults.set(Settings.GPTAPIKEY, forKey:"GPTAPIKEY")
		defaults.set(Settings.mode, forKey:"mode")
	}
	
	
}

class MenuHandler: NSObject {
	@objc func toggleSetting(_ sender: NSMenuItem) {
		sender.state = (sender.state == .off) ? .on : .off
		
		switch sender.title {
		case "Target Window":
			Settings.targetWindow = sender.state == .on
		case "Auto Scan":
			Settings.autoScan = sender.state == .on
		case "Reset Position on Scan":
			Settings.positionReset = sender.state == .on
		case "Positional Audio":
			Settings.positionalAudio = sender.state == .on
		case "Move Mouse":
			Settings.moveMouse = sender.state == .on
		case "Launch on Login":
			Settings.launchOnBoot = sender.state == .on
		default: break
		}
		
		Settings.save()
	}
	
	
	@objc func toggleAutoScan(_ sender: NSMenuItem) {
		toggleSetting(sender)
		if Settings.autoScan {
			Settings.installMouseMonitor()
		} else {
			Settings.removeMouseMonitor()
		}
	}
	
	
	@objc func toggleLaunch(_ sender: NSMenuItem) {
		toggleSetting(sender)
		let fileManager = FileManager.default
		let home = fileManager.homeDirectoryForCurrentUser
		let launchPath = "Library/LaunchAgents/com.chikim.VOCR.plist"
		let launchFile = home.appendingPathComponent(launchPath)
		if Settings.launchOnBoot {
			if !fileManager.fileExists(atPath: launchFile.path) {
				let bundle = Bundle.main
				let bundlePath = bundle.path(forResource: "com.chikim.VOCR", ofType: "plist")
				try! fileManager.copyItem(at: URL(fileURLWithPath: bundlePath!), to: launchFile)
			} else {
				try!fileManager.removeItem(at: launchFile)
			}
		}
	}
	
	@objc func presentApiKeyInputDialog(_ sender: AnyObject?) {
		Settings.displayApiKeyDialog()
	}
	
	@objc func displayAboutWindow(_ sender: Any?) {
		let storyboardName = NSStoryboard.Name(stringLiteral: "Main")
		let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
		let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "aboutWindowStoryboardID")
		if let aboutWindowController = storyboard.instantiateController(withIdentifier: storyboardID) as? NSWindowController {
			NSApplication.shared.activate(ignoringOtherApps: true)
			aboutWindowController.showWindow(nil)
		}
	}
	
	@objc func chooseOutput(_ sender: Any?) {
		let alert = NSAlert()
		alert.alertStyle = .informational
		alert.messageText = "Sound Output"
		alert.informativeText = "Choose an Output for positional audio feedback."
		let devices = AudioEngine.outputDevices
		for device in devices {
			alert.addButton(withTitle: device.name)
		}
		
		let modalResult = alert.runModal()
		let n = modalResult.rawValue-1000
		Player.shared.engine.stop()
		try! Player.shared.engine.setDevice(AudioEngine.outputDevices[n])
		try! Player.shared.engine.start()
	}
	
	@objc func saveResult(_ sender: NSMenuItem) {
		let savePanel = NSSavePanel()
		savePanel.allowedContentTypes = [.text]
		savePanel.allowsOtherFileTypes = false
		savePanel.begin { (result) in
			if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
				if let url = savePanel.url {
					let text = Navigation.shared.text()
					try! text.write(to: url, atomically: false, encoding: .utf8)
				}
			}
			let windows = NSApplication.shared.windows
			NSApplication.shared.hide(nil)
			windows[1].close()
		}
	}

	@objc func selectMode(_ sender: NSMenuItem) {
		guard let menu = sender.menu else { return }
		for item in menu.items {
			item.state = (item.title == sender.title) ? .on : .off
		}
		Settings.mode = sender.title
		Settings.save()
	}
	
}

