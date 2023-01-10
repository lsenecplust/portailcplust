import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatefulWidget {
  final Duration duration;
  final Function(String code) ondetect;
  const Scanner(
      {super.key,
      this.duration = const Duration(milliseconds: 500),
      required this.ondetect});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  bool isdetected = false;
  bool isScanning = false;
  bool isLoading = false;

  void toogleScanner() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isScanning = !isScanning;
      isLoading = true;
    });
    Future.delayed(widget.duration).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void onDetect(Barcode value) {
    toogleScanner();
    widget.ondetect(value.rawValue ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
            onPressed: toogleScanner,
            icon: const Icon(Icons.qr_code),
            label: const Text("Scanner")),
        AnimatedContainer(
          duration: widget.duration,
          height: isScanning ? 200 : 0,
          width: isScanning ? 200 : 0,
          child: Builder(builder: (context) {
            if (isScanning == false) return Container();
            if (isLoading == true) return Container();

            return BarCodeScanner(
              onDetect: onDetect,
            );
          }),
        ),
      ],
    );
  }
}

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
      fit: BoxFit.cover,
      onDetect: (barcode, args) {
        controller.stop();
        widget.onDetect(barcode);
      },
    );
  }
}
