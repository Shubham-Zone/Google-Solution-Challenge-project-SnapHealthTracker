// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// // import 'package:heal_snap/Helpers/Charts.dart';
// import 'package:wakelock/wakelock.dart';
//
// class HomePage extends StatefulWidget {
//
//   const HomePage({super.key});
//
//   @override
//   HomePageView createState() {
//     return HomePageView();
//   }
// }
//
// class HomePageView extends State<HomePage> {
//
//   bool _toggled = false;
//   bool _processing = false;
//   final List<SensorValue> _data = [];
//   late CameraController _controller;
//   final double _alpha = 0.3;
//   final int _bpm = 0;
//
//   _toggle() {
//     _initController().then((onValue) {
//       Wakelock.enable();
//       setState(() {
//         _toggled = true;
//         _processing = false;
//       });
//       _updateBPM();
//     });
//   }
//
//   _untoggle() {
//     _disposeController();
//     Wakelock.disable();
//     setState(() {
//       _toggled = false;
//       _processing = false;
//     });
//   }
//
//   Future<void> _initController() async {
//     try {
//       List cameras = await availableCameras();
//       _controller = CameraController(cameras.first, ResolutionPreset.low);
//       await _controller.initialize();
//       Future.delayed(const Duration(milliseconds: 500)).then((onValue) {
//         _controller.setFlashMode(FlashMode.torch);
//       });
//       _controller.startImageStream((CameraImage image) {
//         if (!_processing) {
//           setState(() {
//             _processing = true;
//           });
//           _scanImage(image);
//         }
//       });
//     } on Exception {
//       // print(Exception);
//     }
//   }
//
//   _updateBPM() async {
//     List<SensorValue> values;
//     double avg;
//     int n;
//     double m;
//     double threshold;
//     double bpm;
//     int counter;
//     int previous;
//     while (_toggled) {
//       values = List.from(_data);
//       avg = 0;
//       n = values.length;
//       m = 0;
//       for (var value in values) {
//         avg += value.value / n;
//         if (value.value > m) m = value.value;
//       }
//       threshold = (m + avg) / 2;
//       bpm = 0;
//       counter = 0;
//       previous = 0;
//       for (int i = 1; i < n; i++) {
//         if (values[i - 1].value < threshold &&
//             values[i].value > threshold) {
//           if (previous != 0) {
//             counter++;
//             bpm +=
//                 60000 / (values[i].time.millisecondsSinceEpoch - previous);
//           }
//           previous = values[i].time.millisecondsSinceEpoch;
//         }
//       }
//       if (counter > 0) {
//         bpm = bpm / counter;
//         setState(() {
//           bpm = (1 - _alpha) * bpm + _alpha * bpm;
//         });
//       }
//       await Future.delayed(Duration(milliseconds: (1000 * 50 / 30).round()));
//     }
//   }
//
//   _scanImage(CameraImage image) {
//     double avg =
//         image.planes.first.bytes.reduce((value, element) => value + element) /
//             image.planes.first.bytes.length;
//     if (_data.length >= 50) {
//       _data.removeAt(0);
//     }
//     setState(() {
//       _data.add(SensorValue(DateTime.now(), avg));
//     });
//     Future.delayed(const Duration(milliseconds: 1000 ~/ 30)).then((onValue) {
//       setState(() {
//         _processing = false;
//       });
//     });
//   }
//
//   _disposeController() {
//     _controller.dispose();
//     _controller.dispose();
//   }
//
//   @override
//   void dispose() {
//     _disposeController();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: Center(
//                       child: _controller == null
//                           ? Container()
//                           : CameraPreview(_controller),
//                     ),
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         (_bpm > 30 && _bpm < 150 ? _bpm.round().toString() : "--"),
//                         style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: IconButton(
//                   icon: Icon(_toggled ? Icons.favorite : Icons.favorite_border),
//                   color: Colors.red,
//                   iconSize: 128,
//                   onPressed: () {
//                     if (_toggled) {
//                       _untoggle();
//                     } else {
//                       _toggle();
//                     }
//                   },
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 margin:  const EdgeInsets.all(12),
//                 decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(18),
//                     ),
//                     color: Colors.black),
//                 child: Chart(_data),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }