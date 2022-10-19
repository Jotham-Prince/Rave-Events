import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'package:rave_events/screens/Home/payment_info.dart';

class ScanQrPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.resumeCamera();
    controller.scannedDataStream.listen((qrData) {
      setState(() async {
        result = qrData;
        if (result?.format == BarcodeFormat.qrcode) {
          try {
            final paymentInfo = jsonDecode(result?.code ?? "");
            await controller.pauseCamera();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayPaymentsInfo(
                          paymentInfo: paymentInfo,
                          controller: controller,
                        )));
          } on FormatException {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Invalid Qr Code!"),
            ));
          } on Exception {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("An unknown error occured"),
            ));
          }
        }
      });
    });
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 250,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
