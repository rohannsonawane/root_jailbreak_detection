import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'root_detection_platform_interface.dart';

/// An implementation of [RootDetectionPlatform] that uses method channels.
class MethodChannelRootDetection extends RootDetectionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('root_detection');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
