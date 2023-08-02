import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';
import 'package:portail_canalplustelecom_mobile/auth.dart';
import 'package:portail_canalplustelecom_mobile/class/log.dart';
import 'package:portail_canalplustelecom_mobile/keycloakRedirection/platform_impl/keycloack.base.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KeycloackImpl extends BaseLogin {
  KeycloackImpl(AuthorizationCodeGrant grant, Uri keycloakUri)
      : super(grant, keycloakUri);

  @override
  Widget login() => KeycloackMobile(grant, keycloakUri).loginMobile();
}

class KeycloackMobile {
  final AuthorizationCodeGrant grant;
  final Uri keycloackUri;

  KeycloackMobile(this.grant, this.keycloackUri);

  Widget loginMobile() => _KeycloackWebView(
        grant: grant,
        keycloakUri: keycloackUri,
      );
}

class _KeycloackWebView extends StatefulWidget {
  final AuthorizationCodeGrant grant;
  final Uri keycloakUri;
  const _KeycloackWebView(
      {Key? key, required this.grant, required this.keycloakUri})
      : super(key: key);

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
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Center(child: Text("Application starting..."))));
            }
            OAuthManager.of(context)?.onHttpInit(await widget.grant
                .handleAuthorizationResponse(responseUrl.queryParameters));

            if (mounted) {
              var shadowuri = Uri.parse(responseUrl.toString());
              Map<String, String> query = Map.from(shadowuri.queryParameters);

              if (query.containsKey("code")) query["code"] = "***";
              if (query.containsKey("session_state")) {
                query["session_state"] = "***";
              }
              shadowuri = shadowuri.replace(queryParameters: query);
              var url =
                  "${shadowuri.origin}${shadowuri.path}?${Uri.decodeFull(shadowuri.query)}";

              Log.keycloack.info(context, "NavigationDecision.prevent $url");
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(widget.grant.getAuthorizationUrl(widget.keycloakUri));
    //redirect to authorizationEndpoint simplifie la conf keycloack. De plus on intercept le redirect, on le kill et on recup le authCode
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: controller));
  }
}
