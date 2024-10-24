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
