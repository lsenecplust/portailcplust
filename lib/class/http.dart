import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:portail_canalplustelecom_mobile/main.dart';

class Http {
  Http._initme();
  static final Http instance = Http._initme();
  oauth2.Client? client;

  Future<String> get(BuildContext context, String url) {
    if (client == null) throw Exception("http client is null");
    return client!.get(Uri.parse((url))).then((response) {
      if (response.statusCode == 401) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const RootContainer()));
      }
      return response.body;
    }).onError((error, stackTrace) => throw Exception(error));
  }
}
