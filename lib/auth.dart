import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:portail_canalplustelecom_mobile/class/app.config.dart';
import 'package:portail_canalplustelecom_mobile/class/exceptions.dart';

class Auth extends StatefulWidget {
  const Auth({
    Key? key,
    required this.child,
    required this.errorWidget,
    this.authenticateHttpClient,
  }) : super(key: key);
  final Widget child;
  final Widget errorWidget;
  final AuthenticateHttpClient? authenticateHttpClient;
  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  late AuthenticateHttpClient authenticateHttp =
      widget.authenticateHttpClient ?? AuthenticateHttpClient();

  @override
  Widget build(BuildContext context) {
    return OAuthManager(
        authenticateHttp: authenticateHttp,
        onHttpInit: (value) => setState(() {
              authenticateHttp.client = value;
            }),
        child: _AuthHandler(
          errorWidget: widget.errorWidget,
          child: widget.child,
        ));
  }
}

class OAuthManager extends InheritedWidget {
  const OAuthManager({
    super.key,
    required super.child,
    required this.authenticateHttp,
    required this.onHttpInit,
  });

  final AuthenticateHttpClient authenticateHttp;
  final ValueChanged<Client?> onHttpInit;

  static OAuthManager? of(BuildContext context) {
    var oauth = context.dependOnInheritedWidgetOfExactType<OAuthManager>();
    assert(oauth != null, "OAuthManager not found in widgetTree");
    return oauth;
  }

  @override
  bool updateShouldNotify(OAuthManager oldWidget) =>
      oldWidget.onHttpInit != onHttpInit;

  Future<dynamic> get(BuildContext context, String url,
          {Map<String, String>? params}) =>
      _sendQuery(context,
          () => client!.get(Uri.parse(url).replace(queryParameters: params)));

  Future<dynamic> post(BuildContext context, String url, Object body,
          {Map<String, String>? params}) =>
      _sendQuery(
          context,
          () => client!.post(Uri.parse(url).replace(queryParameters: params),
              body: body));

  Future<dynamic> _sendQuery(
      BuildContext context, Future<http.Response> Function() method) async {
    assert(client != null, "authenticateHttp.client cannot be null");

    debugPrint(client?.credentials.accessToken);
    debugPrint("[expiration]=${client?.credentials.expiration}");
    debugPrint("[canRefresh]=${client?.credentials.canRefresh}");
    debugPrint("[isExpired]=${client?.credentials.isExpired}");

    if (isLogged == false) {
      OAuthManager.of(context)?.onHttpInit(null); //Redirige vers la page login
    }
    try {
      var response = await method().timeout(const Duration(seconds: 10));
      if (response.statusCode == 403) {
        return Future.error(UnAuthorise(message: response.body));
      }
      if (response.statusCode == 404) {
        return Future.error(NotFound());
      }
      return jsonDecode(response.body);
    } on AuthorizationException catch (e) {
      client!.close();
      OAuthManager.of(context)?.onHttpInit(null); //Redirige vers la page login
      return Future.error(
          UnAuthorise(message: "${e.error} : ${e.description}"));
    } on TimeoutException catch (_) {
      return Future.error(TimeOut());
    } catch (e) {
      return Future.error(Internal());
    }
  }

  Client? get client => authenticateHttp.client;
  bool get _isExpired => client?.credentials.isExpired ?? true;
  bool get _canRefresh => client?.credentials.canRefresh ?? false;
  bool get isLogged => _isExpired == false || _canRefresh;

  navigatePush(BuildContext context, Widget child) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Auth(
                authenticateHttpClient: authenticateHttp,
                errorWidget: Container(),
                child: child)));
  }

    navigatePushReplacement(BuildContext context, Widget child) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Auth(
                authenticateHttpClient: authenticateHttp,
                errorWidget: Container(),
                child: child)));
  }
}

class _AuthHandler extends StatefulWidget {
  final Widget child;
  final Widget errorWidget;
  const _AuthHandler({Key? key, required this.child, required this.errorWidget})
      : super(key: key);

  @override
  State<_AuthHandler> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<_AuthHandler> {
  @override
  Widget build(BuildContext context) {
    if (OAuthManager.of(context)?.isLogged ?? false) return widget.child;
    return Scaffold(
        body: _KeycloackWebView(
      grant: AuthorizationCodeGrant(
        ApplicationConfiguration.instance!.keycloak.clientid,
        ApplicationConfiguration.instance!.keycloak.authorizationEndpoint,
        ApplicationConfiguration.instance!.keycloak.tokenEndpoint,
      ),
    ));
  }
}

class _KeycloackWebView extends StatefulWidget {
  final AuthorizationCodeGrant grant;
  const _KeycloackWebView({
    Key? key,
    required this.grant,
  }) : super(key: key);

  @override
  State<_KeycloackWebView> createState() => _KeycloackWebViewState();
}

class _KeycloackWebViewState extends State<_KeycloackWebView> {
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
            debugPrint(responseUrl.toString());
            if (responseUrl.queryParameters['execution'] == "UPDATE_PASSWORD") {
              return NavigationDecision.navigate;
            }
            OAuthManager.of(context)?.onHttpInit(await widget.grant
                .handleAuthorizationResponse(responseUrl.queryParameters));

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(widget.grant.getAuthorizationUrl(Uri.parse(
          ApplicationConfiguration.instance!.keycloak
              .issuer))); //redirect to authorizationEndpoint simplifie la conf keycloack. De plus on intercept le redirect, on le kill et on recup le authCode
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: controller));
  }
}

class AuthenticateHttpClient {
  Client? client;
  AuthenticateHttpClient({this.client});
}
