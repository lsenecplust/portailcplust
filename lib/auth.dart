// ignore_for_file: implementation_imports


import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

// https://re7.oss.canalplustelecom.com/dev/auth/realms/OSS-RECETTE/.well-known/openid-configuration
const issuer =
    "https://re7.oss.canalplustelecom.com/dev/auth/realms/OSS-RECETTE";
final authorizationEndpoint = Uri.parse("$issuer/protocol/openid-connect/auth");
final tokenEndpoint = Uri.parse("$issuer/protocol/openid-connect/token");
const clientid = 'portail_canalplustelecom';
const secret = null;
Uri redirectUrl = Uri.parse('apps://apps.portail.canalplustelecom.mobile');

class Auth {
  Auth._initme();
  static final Auth instance = Auth._initme();
  oauth2.Client? client;
}

class AuthHandler extends StatelessWidget {
  final Widget child;
  final Widget errorWidget;
  const AuthHandler(
      {super.key, required this.child, required this.errorWidget});

  Future<oauth2.Client> createClient() async {
    var grant = oauth2.AuthorizationCodeGrant(
        clientid, authorizationEndpoint, tokenEndpoint,
        secret: secret);
    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl);
    launchUrl(authorizationUrl, mode: LaunchMode.externalApplication);

    // ------- 8< -------

    Uri? responseUrl;
    await for (var uri in linkStream) {
      if (uri?.startsWith(redirectUrl.toString()) ?? false) {
        responseUrl = Uri.parse(uri!);
        break;
      }
    }

    if (responseUrl == null) throw Exception("Unexpexted");
    return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomFutureBuilder(
        future: createClient(),
        builder: (context, snapshotClient) {
          Auth.instance.client = snapshotClient.data!;
          return child;
        },
      ),
    );
  }
}
