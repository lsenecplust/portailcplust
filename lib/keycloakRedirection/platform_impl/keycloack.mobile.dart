import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';
import 'package:portail_canalplustelecom_mobile/auth.dart';
import 'package:portail_canalplustelecom_mobile/class/log.dart';
import 'package:portail_canalplustelecom_mobile/keycloakRedirection/platform_impl/keycloack.base.dart';
import 'package:portail_canalplustelecom_mobile/widgets/somethingwentwrong.dart';
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
  late NavigationDelegate _navigationDelegate;
  String? logmessage = "";
  WebResourceError? networkError;
  bool isNetworkError = false;
  bool reloading = false;
  @override
  void initState() {
    _navigationDelegate = NavigationDelegate(
      onWebResourceError: (error) {
        networkError = error;
      },
      onPageStarted: (url) {
        networkError = null;
      },
      onPageFinished: (url) async {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          isNetworkError = networkError != null;
          reloading = false;
        });
      },
      onNavigationRequest: (NavigationRequest request) async {
        log("verify code...");
        var responseUrl = Uri.parse(request.url);
        log("verify code : ${responseUrl.toString()}");
        debugPrint("NavigationRequest =>$responseUrl");

        if (responseUrl.queryParameters['code']?.isEmpty ?? true) {
          log(null);
          return NavigationDecision.navigate;
        }
        if (OAuthManager.of(context) == null) log("OAuthManager is null");
        log("setting client http");
        OAuthManager.of(context)?.onHttpInit(await widget.grant
            .handleAuthorizationResponse(responseUrl.queryParameters));

        loguri(responseUrl);
        log("authentification done");

        return NavigationDecision.prevent;
      },
    );

    super.initState();
    controller = WebViewController()
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(_navigationDelegate)
      ..loadRequest(widget.grant.getAuthorizationUrl(widget.keycloakUri));
    //redirect to authorizationEndpoint simplifie la conf keycloack. De plus on intercept le redirect, on le kill et on recup le authCode
  }

  void log(String? msg) => setState(() {
        logmessage = msg;
      });

  void loguri(Uri responseUrl) {
    try {
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
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      if (isNetworkError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SomethingWenWrong(
                iconsize: 70,
                line1: "Erreur de réseaux",
                line2: "Verifiez votre connection internet",
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: reloading
                    ? const CircularProgressIndicator()
                    : TextButton(
                        onPressed: () {
                          controller.reload();
                          setState(() {
                            reloading = true;
                          });
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh),
                            Text("Réessayer"),
                          ],
                        )),
              )
            ],
          ),
        );
      }
      return Stack(
        children: [
          WebViewWidget(controller: controller),
          Align(
              alignment: Alignment.bottomCenter, child: Text(logmessage ?? ""))
        ],
      );
    }));
  }
}
