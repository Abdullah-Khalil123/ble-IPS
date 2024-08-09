import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get_navigation/src/snackbar/snackbar_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  final Map<String, DiscoveredDevice> _discoveredDevices = {};
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _startScan();
    _startUpdateTimer();
  }

  void _startScan() {
    _ble.scanForDevices(
      withServices: [], // Optionally specify services to scan for
      scanMode: ScanMode.lowLatency,
    ).listen((device) {
      setState(() {
        if (device.connectable == Connectable.available) {
          _discoveredDevices[device.id] = device;
        }
      });
    }).onError((error) {
      print("Error during scan: $error");
    });
  }

  void _startUpdateTimer() {
    _updateTimer =
        Timer.periodic(const Duration(microseconds: 100), (Timer timer) {
      setState(() {
        // DO ANYTHING OR NOTHING I DONT KNOW
      });
    });
  }

  double _calculateDistance(int rssi) {
    const txPower =
        -60; // This is a common value, but you should measure it for accuracy
    const pathLossExponent = 4.0; // between 2 and 4
    if (rssi == 0) return -1.0;
    final ratio = rssi / txPower;
    return 0.1 * pow(ratio, pathLossExponent).toDouble();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void requestPermissions() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      Fluttertoast.showToast(
        msg: "Location permission granted.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else if (status.isDenied) {
      Fluttertoast.showToast(
        msg: "Location permission denied.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else if (status.isPermanentlyDenied) {
      Fluttertoast.showToast(
        msg:
            "Location permission permanently denied. Please enable it in settings.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Scanner'),
      ),
      body: ListView.builder(
        itemCount: _discoveredDevices.length,
        itemBuilder: (context, index) {
          final device = _discoveredDevices.values.elementAt(index);
          final distance = _calculateDistance(device.rssi).toStringAsFixed(2);
          return ListTile(
            title: Text(device.name.isEmpty ? device.id : device.name),
            subtitle: Text(
              '$distance meters',
              style: const TextStyle(fontSize: 24),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _discoveredDevices.clear();
            _startScan();
          });
        },
        tooltip: 'Scan Again',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
