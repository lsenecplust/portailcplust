
import 'package:portail_canalplustelecom_mobile/class/scanresult.dart';
import 'package:portail_canalplustelecom_mobile/class/string.extension.dart';

extension ScanResultExtension on ScanResult {
   bool get isNumdec => data.isNumdec;
   bool get isOntSerial =>  data.isOntSerial;
   bool get isSerial =>  data.isSerial;
   bool get isMac =>  data.isMac;
}