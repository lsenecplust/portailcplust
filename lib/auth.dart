import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:portail_canalplustelecom_mobile/class/app.config.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'class/authenticatedhttp.dart';


final authorizationEndpoint = Uri.parse("${ApplicationConfiguration.keycloack.issuer}/protocol/openid-connect/auth");
final tokenEndpoint = Uri.parse("${ApplicationConfiguration.keycloack.issuer}/protocol/openid-connect/token");


class AuthHandler extends StatefulWidget {
  final Widget child;
  final Widget errorWidget;
  const AuthHandler(
      {super.key, required this.child, required this.errorWidget});

  @override
  State<AuthHandler> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {
  bool isLogged = AuthenticatedHttp.instance.isLogged;
  @override
  Widget build(BuildContext context) {
    if (isLogged) return widget.child;
    return Scaffold(
        body: KeycloackWebView(
      grant: oauth2.AuthorizationCodeGrant(
        ApplicationConfiguration.keycloack.clientid,
        authorizationEndpoint,
        tokenEndpoint,
      ),
      onLogged: () {
        setState(() {
          isLogged = AuthenticatedHttp.instance.isLogged;
        });
      },
    ));
  }
}

class KeycloackWebView extends StatefulWidget {
  final oauth2.AuthorizationCodeGrant grant;
  final Function() onLogged;
  const KeycloackWebView({
    Key? key,
    required this.grant,
    required this.onLogged,
  }) : super(key: key);

  @override
  State<KeycloackWebView> createState() => _KeycloackWebViewState();
}

class _KeycloackWebViewState extends State<KeycloackWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            var responseUrl = Uri.parse(request.url);
            AuthenticatedHttp.instance.client = await widget.grant
                .handleAuthorizationResponse(responseUrl.queryParameters);
            widget.onLogged();
            return NavigationDecision.prevent; //TODO : laisser passer les url update password
          },
        ),
      )
      ..loadRequest(widget.grant.getAuthorizationUrl(
        Uri.parse(ApplicationConfiguration.keycloack.issuer))); //redirect to authorizationEndpoint simplifie la conf keycloack. De plus on intercept le redirect, on le kill et on recup le authCode
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: controller));
  }
}
