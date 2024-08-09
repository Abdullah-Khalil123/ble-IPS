// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'BLE Scanner',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final FlutterBluePlus _flutterBlue = FlutterBluePlus();
//   final List<ScanResult> _scanResults = [];

//   @override
//   void initState() {
//     super.initState();
//     _startScan();
//   }

//   void _startScan() {
//     _flutterBlue.scan(timeout: Duration(seconds: 4)).listen((scanResult) {
//       setState(() {
//         _scanResults.add(scanResult);
//       });
//     }).onDone(() {
//       print("Scan completed");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('BLE Scanner'),
//       ),
//       body: ListView.builder(
//         itemCount: _scanResults.length,
//         itemBuilder: (context, index) {
//           final result = _scanResults[index];
//           return ListTile(
//             title: Text(result.device.name.isEmpty
//                 ? 'Unnamed Device'
//                 : result.device.name),
//             subtitle: Text('ID: ${result.device.id}\nRSSI: ${result.rssi}'),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _scanResults.clear();
//             _startScan();
//           });
//         },
//         child: Icon(Icons.refresh),
//         tooltip: 'Scan Again',
//       ),
//     );
//   }
// }
