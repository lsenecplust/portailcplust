import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:portail_canalplustelecom_mobile/main.dart';

class AuthenticatedHttp {
  AuthenticatedHttp._initme();
  static final AuthenticatedHttp instance = AuthenticatedHttp._initme();
  oauth2.Client? client;

  reset() => client = null;
  reloadApp(BuildContext context) => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const MainApp()));
  relog(BuildContext context) {
    reset();
    reloadApp(context);
  }

  Future<dynamic> get(BuildContext context, String url) {
    if (client == null) relog(context);
    return client!.get(Uri.parse((url))).then((response) {
      if (response.statusCode == 403) relog(context);
      return jsonDecode(response.body);
    }).onError((error, stackTrace) {
      if (error is oauth2.AuthorizationException) {
        switch (error.error) {
          case "invalid_grant":
            relog(context);
            return "redirect";
          default:
            return "redirect";
        }
      } else {
        throw Exception(error);
      }
    });
  }

  bool get _isExpired => client?.credentials.isExpired ?? true;
  bool get _canRefresh => client?.credentials.canRefresh ?? false;

  bool get isLogged => _isExpired == false || _canRefresh;
}
