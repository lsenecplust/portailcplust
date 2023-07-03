import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';
import 'package:portail_canalplustelecom_mobile/keycloakRedirection/platform_impl/keycloack.base.dart';

class KeycloackImpl extends BaseLogin {
  KeycloackImpl(AuthorizationCodeGrant grant, Uri keycloakUri)
      : super(grant, keycloakUri);
  @override
  Widget login() {
    throw Exception("Stub implementation");
  }
}
