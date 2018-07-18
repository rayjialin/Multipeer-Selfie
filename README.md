# Multipeer-Selfie

## Overview
The app is great for group of users to take selfie with more controls and save the hassle to share photos to the group.

The whole idea of this app is to allow a group of users to setup an iPhone as camera and rest of the iPhones as remote to take full control of the camera device (setting timer, turn on/off flashlight, capture photo/video) and the captured photo would be synchronized on all the connected devices.

This app leverages the Multipeer Connectivity Framework to allow the devices to communicate over WiFi or Bluetooth.  This app allows 7 devices to be connected at the same time.  the max allowed devices can be changed in the code.

## Screenshots
![alt text](https://github.com/rayjialin/Multipeer-Selfie/blob/master/Docs/Assets/Screenshots/ss01.png)
![alt text](https://github.com/rayjialin/Multipeer-Selfie/blob/master/Docs/Assets/Screenshots/ss02.png)
![alt text](https://github.com/rayjialin/Multipeer-Selfie/blob/master/Docs/Assets/Screenshots/ss05.png)
![alt text](https://github.com/rayjialin/Multipeer-Selfie/blob/master/Docs/Assets/Screenshots/ss03.png)

## Technical Requirements
* iOS version 8 or later
* OSX: 10.9 or higher
* Xcode version 8.3.3 or later
* iPhone 6 or later
* Carthage
* WiFi or Bluetooth

## Getting Started
1. Clone this repository
2. If you don't already have Carthage installed, download Carthage [here](https://github.com/Carthage/Carthage/releases)
3. Once Carthage is installed, navigate to the root directory of this project and run ```Carthage update``` in command line
4. Download GPUImage2 [here](https://github.com/BradLarson/GPUImage2), and follow the instruction to include framework in the project
5. Update the bundle identifier
6. Build and run the app
    
## How to contribute to the development of this app?
Feel free to fork this repo, look at the to-do list, implement them under new branch, and make a pull request.

### To-Dos
- ~~Allow user to go back to home screen to reset camera role and remote roles~~
- ~~Currently the photo is saved to remote devices' photo album, and a thumbnail is displayed on remote devices' bottom right screen, user should be able to tap on the thumbnail to bring up the image in full screen mode with editing functionality, and user should be able to manually save the photo there by press and hold on the photo for 2 seconds~~ pending: add editing functionality 
- Add file transfer progress bar if remote control device is receiving a file
- ~~Make a more aesthetically pleasing UI~~
- Share your newly taken photos on Facebook and Twitter using UIActivityViewController
- Allow the recording and sharing of video clips
- Allow the device acting as the remote control to receive a live video feed
- Allow multiple devices to act as cameras
- Refactor code
- ~~Come up with a better name than "Selfie-Party"~~ I clearly suck at naming an app
- Fix issue where user can tap on buttons multiple times before view is segue to next view
- Add shadow and animation to shutter button to make it "pressable"
- Add options on photo gallery screen to allow user to sort and delete photos
- User GPUImage2 to allow filter effect on photo and video live rendering
