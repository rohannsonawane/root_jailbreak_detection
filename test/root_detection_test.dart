import 'package:flutter_test/flutter_test.dart';
import 'package:root_detection/root_detection.dart';
import 'package:root_detection/root_detection_platform_interface.dart';
import 'package:root_detection/root_detection_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRootDetectionPlatform
    with MockPlatformInterfaceMixin
    implements RootDetectionPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final RootDetectionPlatform initialPlatform = RootDetectionPlatform.instance;

  test('$MethodChannelRootDetection is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRootDetection>());
  });

  test('getPlatformVersion', () async {
    RootDetection rootDetectionPlugin = RootDetection();
    MockRootDetectionPlatform fakePlatform = MockRootDetectionPlatform();
    RootDetectionPlatform.instance = fakePlatform;

    expect(await rootDetectionPlugin.getPlatformVersion(), '42');
  });
}
