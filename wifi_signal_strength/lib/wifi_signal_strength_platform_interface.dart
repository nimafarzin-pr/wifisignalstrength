import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'wifi_signal_strength_method_channel.dart';

abstract class WifiSignalStrengthPlatform extends PlatformInterface {
  /// Constructs a WifiSignalStrengthPlatform.
  WifiSignalStrengthPlatform() : super(token: _token);

  static final Object _token = Object();

  static WifiSignalStrengthPlatform _instance = MethodChannelWifiSignalStrength();

  /// The default instance of [WifiSignalStrengthPlatform] to use.
  ///
  /// Defaults to [MethodChannelWifiSignalStrength].
  static WifiSignalStrengthPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WifiSignalStrengthPlatform] when
  /// they register themselves.
  static set instance(WifiSignalStrengthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
