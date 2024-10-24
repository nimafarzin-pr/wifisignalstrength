# Wifi Signal Strength Plugin

This Flutter plugin allows you to fetch the Wi-Fi signal strength on Android and iOS :(. It uses platform-specific code to determine the current signal level. However, due to platform limitations, some conditions need to be met for this feature to work properly.

## Features

- Flutter platform channel
- Retrieve Wi-Fi signal strength.

## Setup Requirements

### Android

To use the Wi-Fi signal strength feature on Android, ensure the following:

1. **Permissions**: The app must have the necessary permissions for accessing Wi-Fi information:
   - `ACCESS_WIFI_STATE`
   - `ACCESS_FINE_LOCATION`
2. **Location Services**: Location services must be enabled on the device because Android requires it to scan for Wi-Fi networks.

3. **Target API Level**: Make sure your `minSdkVersion` is at least 21, and the app targets at least API level 29 (Android 10).

### iOS

For iOS, the following conditions apply:
"We Geting the name of the connected access point when signal strength information is not available for ios."

1. **Network Extension Entitlement**: You need to configure the `NetworkExtension` entitlement to access certain network-related information, such as Wi-Fi signal strength.
2. **Hotspot Helper Requirements**: Real-time signal strength updates are available only when your app is registered as a Hotspot Helper for a network.
3. **Permissions**: Make sure to add the `NSLocationWhenInUseUsageDescription` key in your `Info.plist` file to explain why your app needs location access.

### Limitation

If the above conditions are not met, the plugin will only be able to provide the Wi-Fi access point name, and not the actual signal strength. if you want to do above consider following steps:

##### iOS Configuration

To enable Wi-Fi signal strength retrieval on iOS, follow these steps:

1. **Add Location Permissions**: Open your `Info.plist` file and add the following permissions:

   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>We need access to your location to fetch Wi-Fi signal strength.</string>
   <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
   <string>We need access to your location to fetch Wi-Fi signal strength.</string>
   ```

2. **Add Hotspot Helper Entitlement**: Your app needs to have the `com.apple.developer.networking.HotspotHelper` entitlement. To add this:

   - Contact Apple for permission to use this entitlement. It is not available for general use.
   - Once approved, add the entitlement to your `Entitlements.plist`:

   ```xml
   <key>com.apple.developer.networking.HotspotHelper</key>
   <true/>
   ```

3. **Enable Background Modes** (if necessary): To keep monitoring Wi-Fi even when the app is in the background, enable "Location updates" in your app's Background Modes capabilities.

## Installation

Add the plugin to your Flutter project by specifying the local path in the `pubspec.yaml` file:

```yaml
dependencies:
  wifi_signal_strength:
    path: ./wifi_signal_strength
```

Make sure that the specified path points to the directory where the plugin is located.

## Usage

1. **Import the Plugin**:

   ```dart
   import 'package:wifi_signal_strength/wifi_signal_strength.dart';
   ```

2. **Check the Wi-Fi Signal Strength**:

```dart
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wifi_signal_strength/wifi_signal_strength.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WifiSignalScreen(),
    );
  }
}

class WifiSignalScreen extends StatefulWidget {
  const WifiSignalScreen({super.key});

  @override
  _WifiSignalScreenState createState() => _WifiSignalScreenState();
}

class _WifiSignalScreenState extends State<WifiSignalScreen> {
  int? _signalStrength;
  Timer? _timer;

  int tick = 0;

  @override
  void initState() {
    super.initState();
    // Start the timer
    _startPeriodicSignalStrengthCheck();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  void _startPeriodicSignalStrengthCheck() {
    // Set the timer to call the function every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      _getWifiSignalStrength();
      log('Tick : $t');
      setState(() {
        tick = t.tick;
      });
    });
  }

  Future<void> _getWifiSignalStrength() async {
    int? strength = await WifiSignalStrength.getWifiSignalStrength();
    setState(() {
      _signalStrength = strength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wi-Fi Signal Strength'),
      ),
      body: Center(
        child: _signalStrength != null
            ? Column(children: [
                if (Platform.isAndroid)
                  Text('Signal Strength in Db: $_signalStrength%'),
                if (Platform.isIOS) Text('SSID: $_signalStrength%'),
                Text('tick: $tick')
              ])
            : const CircularProgressIndicator(),
      ),
    );
  }
}
```

## Local Plugin Integration

If you prefer not to use the example app generated by the original plugin project, you can follow these steps to integrate the plugin directly into your own Flutter project:

1. **Copy the Plugin Files**: Copy the entire plugin directory (`wifi_signal_strength`) into your main project directory.

2. **Update the `pubspec.yaml`**: Add the local plugin path as shown in the installation section above.

3. **Make Necessary Modifications**: Customize or update the platform-specific code in the `android` and `ios` folders of the copied plugin as needed.

##### Implement Platform-Specific Code

1. **Android Implementation**:

   - Go to the `android/src/main/kotlin/` folder in your plugin directory.
   - Open the main Kotlin file and add the code to fetch Wi-Fi signal strength using Android APIs.

2. **iOS Implementation**:
   - Navigate to the `ios/Classes/` folder of in your plugin directory.
   - Open the main Swift file and add code for retrieving Wi-Fi signal strength using appropriate iOS APIs.

## Troubleshooting

- **Signal strength is always `null` or incorrect**: Ensure that all necessary permissions and entitlements are set up correctly, and that the device meets the conditions mentioned in the Setup Requirements.
- **Plugin not found**: Double-check the local path specified in `pubspec.yaml` and ensure it matches the location of the copied plugin directory.

---

By following this guide, you’ll be able to set up and use the custom plugin in your Flutter project while handling the requirements for accessing Wi-Fi signal strength.
