// import 'dart:async';
// import 'package:flutter/services.dart';

// class RootDetection {
//   static const MethodChannel _channel = MethodChannel('root_detection');

//   static Future<bool> get isDeviceRooted async {
//     final bool isRooted = await _channel.invokeMethod('isDeviceRooted');
//     return isRooted;
//   }

//   getPlatformVersion() {}
// }

import 'dart:async';
import 'package:flutter/services.dart';

class RootDetection {
  static const MethodChannel _channel = MethodChannel('root_detection');

  static Future<bool> get isDeviceRooted async {
    final bool isRooted = await _channel.invokeMethod('isDeviceRooted');
    return isRooted;
  }
}
