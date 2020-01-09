# Welcome to VOCR
**WARNING**: USE AT YOUR OWN RISK! This is in alpha cycle. Many things may not work and change frequently without notice.

VOCR is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY, expressed or implied, of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Please see the [GNU General Public License](http://www.gnu.org/licenses/) for more details.

## ***HIGHLY EXPERIMENTAL***
This branch utilizes VisionKit on MacOS Catalina that take advantage of machine learning for OCR.

This is a standalone app, and it does not rely on Keyboard Maestro, Imagemagick, and Tesseract that the previous VOCR utilized.

<iframe width="560" height="315" src="https://www.youtube.com/embed/maBtR_6KDFs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Download
Here is the direct link to download [VOCR v0.1.0-alpha.10.](https://github.com/chigkim/VOCR/releases/download/v0.1.0-alpha.10/VOCR.v0.1.0-alpha.10.zip)  

## Upgrade from Previous VOCR With Tesseract
You can simply remove VOCR group from Keyboard Maestro and follow the instruction for setup below.

The following steps are optional if you want to remove Imagemagick and Tesseract.

* Download the [latest commit](https://github.com/chigkim/VOCR/archive/master.zip) from master branch.
* Run "uninstall.command" script.

## Setup
* After uncompress, just move the app to your application folder and run it.
* Make sure you can find VOCR running on the menu extra  by pressing vo+m twice.
* Go to VoiceOver Utility, and check Allow VoiceOver to be controlled with AppleScript under general category.
* Turn off screen curtain with vo+shift+f11.
* Hide VoiceOver visuals with vo+command+f11.
* Press command+shift+control+w, and you should get a notification asking you to grant accessibility permission. If VoiceOver doesn't focus on the window automatically, press vo+f1 twice to find system dialog, and you should be able to find it.
* After allowing accessibility permission, press command+shift+control+w, and you should get another notification asking you to allow VOCR to take screenshot of the frontmost window. If you don't get the alert, see if you can find it in the system dialog as you did in the previous step.
* If you can't still find it from the system dialog, go to security and privacy, unlock the setting, then go to choose screen recording under privacy tab, and you should be able to find VOCR app.
* When you check it to allow, it should tell you to quit and restart.
* After restarting the app, and make sure you can find it on the menu extra again.
* As a test, go back to the system preference, and press command+shift+control+w, and you should hear a beep and a Voice prompt saying finished.
* At that point, you should be able to navigate the result with command+control+arrows. Refer to the shortcuts section below for more information.
* When you navigating for the first time, another alert should appear to ask  you to give VOCR access to control VoiceOver for speaking announcements.
* Navigate to Siri preference Using VOCR cursor, and then press vo+f5. VoiceOver should say your mouse is also under Siri.
* Press vo+shift+apce to open Siri preference.
* Press escape to exit navigation mode and free up navigation shortcuts.

## Using Image Recognition under VoiceOver Cursor
* Complete the setup above.
* Move your VoiceOver cursor to the element that you want to recognize.
* Press command+shift+control+v
* If running this feature for the first time, you will get a series of alerts asking you to allow VOCR to: 1. run AppleScript; 2. control VoiceOver to take screenshots; and 3. access desktop folder where VoiceOVer saves screenshots.
* After granting the permission, press the shortcut command+shift+control+v again.

If you want to verify if it works properly, search images on Google image using Safari and try recognize them.

If everything goes well, VOCR will report the top 5 image categories in confidence order. If VOCR categorizes the image as a document, it will apply OCR. You can review the OCR result the same way as the section above, but this does not work with mouse movement.

## Recognize picture from camera
* Press command+shift+control+c
* If running  this feature for the first time, it will display an alert to give VOCR access to your camera
* Give VOCR access to camera in system preference
* Press command+shift+control+c again, and you'll hear a count down.
* Shortly after hearing the camera shutter sound, you should hear the result.

## Settings
Positional audio (command+shift+control+p): As mouse cursor moves you will hear hear audio feedback. Frequency changes responds to vertical move, and pan responds to horizontal move. This feature is useful to explore the interface and discover elements' locations.

Disable/enable reset position (command+shift+control+r): When disabled, the cursor will not reset to the top left corner after every new scan. This feature is useful when you rescan the same window to find new change without losing previous cursor.

## Shortcuts
* OCR Frontmost Window: command+shift+control+w
* Recognize image under VoiceOver cursor: command+shift+control+v
* Recognize picture from camera: command+shift+control+c
* Toggle reset position after scan: command+shift+control+r
* Toggle positional audio feedback: command+shift+control+p

The following shortcuts only works after a scan.

* Move down/up: command+control+down/up arrow
* Move left/right: command+control+left/right arrow
* Previous/next character: command+shift+control+left/right arrow
* Go to top/bottom: command+control+page up/down
* Go to beginning/end horizontally: command+control+left/right arrow
* Exit navigation: escape

## Troubleshooting
* If you hear "nothing found" or just hear the word "the", most likely either you need to turn off VoiceOver screen curtain with vo+shift+f11, or fix accessibility and screen recording  permission in security and privacy preference.
* If you do not hear anything after recognize image under VoiceOver cursor, most likely you need to give   VOCR permissions to 1. send Apple Events, 2. control VoiceOver, and 3. access desktop folder. Usually relaunching VOCR and reissuing the command usually retrigger the alerts to reappear in the system dialogs.
* If you hear just "outdoor" and or "sky", " after issuing camera, you would need to fix the camera access.

Lastly, please enjoy and send me your feedback!

