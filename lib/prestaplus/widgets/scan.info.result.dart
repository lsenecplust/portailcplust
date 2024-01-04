import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/scanresult.dart';

class ScaninfosResult extends ChangeNotifier {
  final List<ScanResult> _results = [];

  List<ScanResult> get results => _results;
  int get length => _results.length;

  void add(ScanResult scr) {
    _results.add(scr);
    notifyListeners();
  }

  void clear() {
    _results.clear();
    notifyListeners();
  }
}
