import 'dart:async';
import 'package:flutter/services.dart';

class WifiSignalStrength {
  static const MethodChannel _channel = MethodChannel('wifi_signal_strength');

  static Future<int?> getWifiSignalStrength() async {
    final int? signalStrength =
        await _channel.invokeMethod('getWifiSignalStrength');
    return signalStrength;
  }
}
