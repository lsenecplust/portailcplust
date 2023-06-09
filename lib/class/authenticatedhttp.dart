import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:portail_canalplustelecom_mobile/class/exceptions.dart';
import 'package:portail_canalplustelecom_mobile/main.app.widget.dart';

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

  Future<dynamic> get(BuildContext context, String url) async {
    if (client == null) relog(context);
    print(client?.credentials.accessToken);
    try {
      var response = await client!.get(Uri.parse((url)));
      if (response.statusCode == 403) relog(context);
      if (response.statusCode == 404) return Future.error(NotFoundException());
      return jsonDecode(response.body);
    } catch (e) {
      if (e is oauth2.AuthorizationException) {
        switch (e.error) {
          case "invalid_grant":
            relog(context);
            return "redirect";
          default:
            return "redirect";
        }
      } else {
        throw Exception(e);
      }
    }
  }

  bool get _isExpired => client?.credentials.isExpired ?? true;
  bool get _canRefresh => client?.credentials.canRefresh ?? false;

  bool get isLogged => _isExpired == false || _canRefresh;
}
