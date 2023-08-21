import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/scanner.widget.dart';

class PrestaplusScanScreen extends StatefulWidget {
  const PrestaplusScanScreen({super.key});

  @override
  State<PrestaplusScanScreen> createState() => _PrestaplusScanScreenState();
}

class _PrestaplusScanScreenState extends State<PrestaplusScanScreen> {
  String? searchPattern;
  String? clientfound;
  @override
  Widget build(BuildContext context) {
    return BarCodeScanner(
      showClientCard: true,
      onSelected: (barcodes) {
        setState(() {
          searchPattern = barcodes.numdec;
        });
      },
    );
  }
}