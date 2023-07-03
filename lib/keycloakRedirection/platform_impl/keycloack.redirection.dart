// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';

import 'package:portail_canalplustelecom_mobile/keycloakRedirection/platform_impl/keycloack.stub.dart'
    if (dart.library.io) 'package:portail_canalplustelecom_mobile/keycloakRedirection/platform_impl/keycloack.mobile.dart'
    if (dart.library.html) 'package:portail_canalplustelecom_mobile/keycloakRedirection/platform_impl/keycloack.web.dart';

class KeycloackRedirection extends StatelessWidget {
  final AuthorizationCodeGrant grant;
  final Uri keycloackUri;
  final KeycloackImpl _login;

  KeycloackRedirection({
    super.key,
    required this.grant,
    required this.keycloackUri,
  }) : _login = KeycloackImpl(grant, keycloackUri);

  @override
  Widget build(BuildContext context) => _login.login();
}
