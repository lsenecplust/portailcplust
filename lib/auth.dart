import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart';
import 'package:portail_canalplustelecom_mobile/keycloakRedirection/platform_impl/keycloack.redirection.dart';

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
    var oauth = context.getInheritedWidgetOfExactType<OAuthManager>();
    assert(oauth != null, "OAuthManager not found in widgetTree");
    return oauth;
  }

  @override
  bool updateShouldNotify(OAuthManager oldWidget) =>
      oldWidget.onHttpInit != onHttpInit;

  Future<dynamic> get(BuildContext context, String url,
      {Map<String, String>? params}) {
    var parsedUrl = Uri.parse(url).replace(queryParameters: params);
    debugPrint("[🌎Url]=$parsedUrl");
    return _sendQuery(context, () => client!.get(parsedUrl));
  }

  Future<dynamic> post(BuildContext context, String url,
      {Object? body, Map<String, String>? params}) {
    var parsedUrl = Uri.parse(url).replace(queryParameters: params);
    debugPrint("[🌎Url]=$parsedUrl");
    debugPrint("[💪body]=${json.encode(body)}");
    return _sendQuery(
        context,
        () => client!.post(parsedUrl,
            body: json.encode(body),
            headers: {"Content-Type": "application/json"}));
  }

  Future<dynamic> postform(BuildContext context, String url,
      {Object? body, Map<String, String>? params}) {
    var parsedUrl = Uri.parse(url).replace(queryParameters: params);
    debugPrint("[🌎Url]=$parsedUrl");
    debugPrint("[💪body]=${json.encode(body)}");
    return _sendQuery(
        context,
        () => client!.post(parsedUrl,
            body: body,
            headers: {"Content-Type": "application/x-www-form-urlencoded"}));
  }

  Future<dynamic> _sendQuery(
      BuildContext context, Future<http.Response> Function() method) async {
    assert(client != null, "authenticateHttp.client cannot be null");

    debugPrint("🔑 Token :${client?.credentials.accessToken}");
    debugPrint("[⏱️expiration]=${client?.credentials.expiration}");
    debugPrint("[⏱️canRefresh]=${client?.credentials.canRefresh}");
    debugPrint("[⏱️isExpired]=${client?.credentials.isExpired}");

    if (isLogged == false) {
      OAuthManager.of(context)?.onHttpInit(null); //Redirige vers la page login
    }
    try {
      var response = await method().timeout(const Duration(seconds: 30));
      if (response.statusCode == 403) {
        return Future.error(UnAuthorise(message: response.body));
      }
      if (response.statusCode == 404) {
        return Future.error(NotFound());
      }
      if (response.statusCode == 204) {
        return Future.value(true);
      }
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return response.body;
      }
    } on AuthorizationException catch (e) {
      client!.close();
      Future.microtask(() => OAuthManager.of(context)
          ?.onHttpInit(null)); //Redirige vers la page login
      return Future.error(
          UnAuthorise(message: "${e.error} : ${e.description}"));
    } on TimeoutException catch (_) {
      return Future.error(TimeOut());
    } catch (e) {
      return Future.error(Internal());
    }
  }

  Future<bool?> logout(BuildContext context) async {
    if (ApplicationConfiguration.instance == null) return Future.value(null);
    if (client == null) return Future.value(null);

    var url =
        ApplicationConfiguration.instance!.keycloak.logoutEndpoint.toString();
    var response = await postform(context, url, body: {
      "client_id": ApplicationConfiguration.instance!.keycloak.clientid,
      "refresh_token": client!.credentials.refreshToken
    });

    debugPrint(json.encode(response));
    return response;
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
  var uri = Uri.parse(ApplicationConfiguration.instance!.keycloak.issuer);

  @override
  Widget build(BuildContext context) {
    if (OAuthManager.of(context)?.isLogged ?? false) return widget.child;

    return KeycloackRedirection(
        keycloackUri: uri,
        grant: AuthorizationCodeGrant(
          ApplicationConfiguration.instance!.keycloak.clientid,
          ApplicationConfiguration.instance!.keycloak.authorizationEndpoint,
          ApplicationConfiguration.instance!.keycloak.tokenEndpoint,
        ));
  }
}

class AuthenticateHttpClient {
  Client? client;
  AuthenticateHttpClient({this.client});
}
