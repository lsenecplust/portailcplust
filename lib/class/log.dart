import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:portail_canalplustelecom_mobile/class/app.config.dart';

class Log {
  static PackageInfo? packageInfo;

  static init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  static String get index =>
      "${ApplicationConfiguration.instance!.elastic.index}-${DateTime.now().year}-${DateTime.now().month}";
  static info(String message) => _log(level: "info", message: message);
  static _log({level, message}) async {
    return; //TODO : enable logging by WebAPI or Nginx reserproxy upstring
    if (ApplicationConfiguration.instance == null) return;
    for (var node in ApplicationConfiguration.instance!.elastic.nodes) {
      try {
        var uri = Uri.parse("$node/$index/doc");
        debugPrint("logging $message to ${uri.toString()}");
        var response = await http.post(uri,
            body: json.encode({
              "level": "$level",
              "message": "$message",
              "version": "${packageInfo?.version}",
              "buildNumber": "${packageInfo?.buildNumber}",
              "packageName": "${packageInfo?.packageName}",
              "appName": "${packageInfo?.appName}",
              "installerStore": "${packageInfo?.installerStore}",
              "buildSignature": "${packageInfo?.buildSignature}",
              "@timestamp": "${DateTime.now().millisecondsSinceEpoch}"
            }));

        if (response.statusCode == 200) {
          debugPrint(response.body);
          break;
        } else {
          debugPrint(response.reasonPhrase);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
