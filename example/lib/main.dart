import 'package:flutter/material.dart';
import 'package:root_detection/root_detection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RootDetectionScreen(),
    );
  }
}

class RootDetectionScreen extends StatefulWidget {
  const RootDetectionScreen({super.key});

  @override
  _RootDetectionScreenState createState() => _RootDetectionScreenState();
}

class _RootDetectionScreenState extends State<RootDetectionScreen> {
  late bool _isRooted;

  @override
  void initState() {
    super.initState();
    _checkRootStatus();
  }

  Future<void> _checkRootStatus() async {
    bool isRooted = await RootDetection.isDeviceRooted;
    setState(() {
      _isRooted = isRooted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Root Detection'),
      ),
      body: Center(
        child:
        // _isRooted == null
        //     ? const CircularProgressIndicator()
        //     :
        Text(_isRooted ? 'Device is rooted' : 'Device is not rooted'),
      ),
    );
  }
}
