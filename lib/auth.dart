// ignore_for_file: implementation_imports

import 'dart:io';

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
final credentialsFile = File('~/.myapp/credentials.json');

class Auth extends StatelessWidget {
  const Auth({super.key});

  Future<oauth2.Client> createClient() async {
    var exists = await credentialsFile.exists();

    // If the OAuth2 credentials have already been saved from a previous run, we
    // just want to reload them.
    if (exists) {
      var credentials =
          oauth2.Credentials.fromJson(await credentialsFile.readAsString());
      return oauth2.Client(credentials, identifier: clientid, secret: secret);
    }

    // If we don't have OAuth2 credentials yet, we need to get the resource owner
    // to authorize us. We're assuming here that we're a command-line application.
    var grant = oauth2.AuthorizationCodeGrant(
        clientid, authorizationEndpoint, tokenEndpoint,
        secret: secret);

    // A URL on the authorization server (authorizationEndpoint with some additional
    // query parameters). Scopes and state can optionally be passed into this method.
    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl);

    //print(authorizationUrl);
    // Redirect the resource owner to the authorization URL. Once the resource
    // owner has authorized, they'll be redirected to `redirectUrl` with an
    // authorization code. The `redirect` should cause the browser to redirect to
    // another URL which should also have a listener.
    //launchUrl(Uri.parse('apps://apps.portail.canalplustelecom.mobile?session_date=fdfsdfsdf'));
    //launchUrl(Uri.parse('https://apps.portail.canalplustelecom.mobile/?session_date=fdfsdfsdf'));
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
          var client = snapshotClient.data!;
          return CustomFutureBuilder(
            future: client.read(Uri.parse(
                'https://re7.oss.canalplustelecom.com/pfs/api/Contrats/rechercher?query=lary sene&isAdress=false')),
            builder: (context, snapshot) {
              return Text(snapshot.data!);
            },
          );

/*
  await auth.credentialsFile.writeAsString(client.credentials.toJson());*/

         // return Text(snapshot.data?.secret ?? "");
        },
      ),
    );
  }
}
