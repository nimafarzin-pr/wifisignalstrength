import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'wifi_signal_strength_platform_interface.dart';

/// An implementation of [WifiSignalStrengthPlatform] that uses method channels.
class MethodChannelWifiSignalStrength extends WifiSignalStrengthPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('wifi_signal_strength');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
