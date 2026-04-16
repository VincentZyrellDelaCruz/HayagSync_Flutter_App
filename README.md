# hayagsync_app

A Flutter project for mobile application incident support for private school bullying documentation and reporting. It connects directly to the Laravel as its backend through API.

## To run api on either emulator or actual device
- Always check the api_constants.dart, kindly read the comments.

## To run flutter app on Android Emulator
- Install Android Studio and create a new virtual device in device manager (watch latest tutorial about that on the internet)
- Select a mobile emulator that you created inside the VScode, then click "Run without debugging" in main.dart
> __Note:__ Your created virtual device (Android SDK) need API 31 or higher 

## To run flutter app on actual Android Device Wirelessly
- Make sure the Developer Options is available, if not go to Settings → About phone → Build number and tap build number 7 times.
- In Developer Options. turn on USB debugging (idk why for wireless)
- Then enable Wireless debugging and Tap Pair device with pairing code (you’ll see an IP address and port).
- Pair your phone with your computer, run this to your terminal/CMD:
    ```bash
    adb pair <device-ip>:<port> # Once you entered, enter the pairing code shown in your phone
    ```
- Then run this:
    ```bash
    adb connect <device-ip>:<port>
    ```
- To verify, run this:
    ```bash
    flutter devices
    ```
- Once your android device appears after the command at the top, run this command:
    ```bash
    flutter run
    ```
- If your phone doesn’t show up, run these two commands:
    ```bash
    adb kill-server
    adb start-server
    ```
> __Note:__ This Wireless debugging is only available on Android 11+
> __Also Note:__ I tried to use "Run without debugging" button instead of flutter run command for hot reload, but it takes forever to install

## To run flutter app on actual Android Device Through USB Cable
- Make sure the Developer Options is available, if not go to Settings → About phone → Build number and tap build number 7 times.
- In Developer Options. turn on USB debugging.
- Connect your phone via USB cable.
- To verify device detection, run this command:
    ```bash
    adb devices
    ```
- If the device shows up, run this:
    ```bash
    flutter run
    ```
> __Note:__ Just like the wireless one, it takes forever to use "Run without debugging" instead of flutter run command

<!-- 
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
 -->