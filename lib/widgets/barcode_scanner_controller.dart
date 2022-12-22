import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarCodeScanner extends StatefulWidget {
  final ValueChanged<Barcode> onDetect;
  const BarCodeScanner({
    Key? key,
    required this.onDetect,
  }) : super(key: key);

  @override
  State<BarCodeScanner> createState() => _BarCodeScannerState();
}

class _BarCodeScannerState extends State<BarCodeScanner> {
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      fit: BoxFit.contain,
      onDetect: (barcode, args) {
        controller.stop();
        widget.onDetect(barcode);
      },
    );
  }

}
