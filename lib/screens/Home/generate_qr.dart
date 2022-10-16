import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScanner extends StatelessWidget {
  Map<String, dynamic> paymentDetails;
  QrCodeScanner({super.key, required this.paymentDetails});
  final qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final qrData = paymentDetails;
    String encodedJson = jsonEncode(qrData);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25),
            Center(
              child: RepaintBoundary(
                key: qrKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 60.0),
                  child: Column(
                    children: [
                      Text(
                        '${paymentDetails['event']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      QrImage(
                        data: encodedJson,
                        size: 250,
                        backgroundColor: Colors.white,
                        version: QrVersions.auto,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
                child: const Text('Save to Gallery'),
                onPressed: () async {
                  PermissionStatus res;
                  res = await Permission.storage.request();
                  if (res.isGranted) {
                    final boundary = qrKey.currentContext!.findRenderObject()
                        as RenderRepaintBoundary;
                    // We can increse the size of QR using pixel ratio
                    final image = await boundary.toImage(pixelRatio: 5.0);
                    final byteData = await (image.toByteData(
                        format: ui.ImageByteFormat.png));
                    if (byteData != null) {
                      final pngBytes = byteData.buffer.asUint8List();
                      // getting directory of our phone
                      final directory =
                          (await getApplicationDocumentsDirectory()).path;
                      final imgFile = File(
                        '$directory/${DateTime.now()}.png',
                      );
                      imgFile.writeAsBytes(pngBytes);
                      GallerySaver.saveImage(imgFile.path)
                          .then((success) async {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Code saved to gallery"),
                        ));
                        Navigator.pop(context);
                      });
                    }
                  }
                }),
            const SizedBox(height: 25)
          ],
        ),
      ),
    );
  }
}
