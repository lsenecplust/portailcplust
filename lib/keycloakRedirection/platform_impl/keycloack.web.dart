// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';
import 'package:portail_canalplustelecom_mobile/keycloakRedirection/platform_impl/keycloack.base.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';

class KeycloackImpl extends BaseLogin {
  KeycloackImpl(AuthorizationCodeGrant grant, Uri redirectUri)
      : super(grant, redirectUri);

  @override
  Widget login() {
    var url = grant.getAuthorizationUrl(keycloakUri);
    Future.microtask(() => window.location.replace(url.toString()));



    return const Scaffold(
      body: Column(
        children: [
          PortailIndicator(),
          Text("Redirection vers keycloack"),
        ],
      ),
    );
  }
}
