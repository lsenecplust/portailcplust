import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:portail_canalplustelecom_mobile/class/app.config.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

import 'main.app.widget.dart';



void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    await ScanditFlutterDataCaptureBarcode.initialize();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  ApplicationConfiguration.setdevelopment();
  runApp(const MainApp());
}