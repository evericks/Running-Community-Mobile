
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key, this.qrCodeImage});
  static const routeName = '/qr-code';
  final Uint8List? qrCodeImage;

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'QR Code'),
      body: Center(
        child: widget.qrCodeImage == null
            ? const CircularProgressIndicator()
            : Image.memory(widget.qrCodeImage!),
      ),
    );
  }
}

