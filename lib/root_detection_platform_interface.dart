import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'root_detection_method_channel.dart';

abstract class RootDetectionPlatform extends PlatformInterface {
  /// Constructs a RootDetectionPlatform.
  RootDetectionPlatform() : super(token: _token);

  static final Object _token = Object();

  static RootDetectionPlatform _instance = MethodChannelRootDetection();

  /// The default instance of [RootDetectionPlatform] to use.
  ///
  /// Defaults to [MethodChannelRootDetection].
  static RootDetectionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RootDetectionPlatform] when
  /// they register themselves.
  static set instance(RootDetectionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
