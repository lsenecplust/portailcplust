import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:portail_canalplustelecom_mobile/class/app.config.dart';

import 'main.app.widget.dart';



void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  ApplicationConfiguration.setproduction();
  runApp(const MainApp());
}