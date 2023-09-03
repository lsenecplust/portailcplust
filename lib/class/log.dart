import 'package:flutter/material.dart';
import 'package:librairies/keycloack_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:portail_canalplustelecom_mobile/class/app.config.dart';

class PrestaPlus extends LocationLogger {}



class KeycloackWebview extends LocationLogger {}



//TODO : permettre de logger sans avoir besoin de s'authentifier sur le keycloak. via une API KEY ?
class LocationLogger extends Log {
@Deprecated('read todo')   void info(BuildContext context, String message) =>
      Log._info(context, runtimeType.toString(), message);
 @Deprecated('read todo') void error(BuildContext context, String message) =>
      Log._error(context, runtimeType.toString(), message);
 @Deprecated('read todo') void debug(BuildContext context, String message) =>
      Log._debug(context, runtimeType.toString(), message);
@Deprecated('read todo')  void warning(BuildContext context, String message) =>
      Log._warning(context, runtimeType.toString(), message);
}

class Log {
  static PackageInfo? packageInfo;
  static PrestaPlus prestaPlus = PrestaPlus();
  static KeycloackWebview keycloack = KeycloackWebview();
  static init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  static void _info(BuildContext context, String location, String message) =>
      _log(context, "information", location, message);
  static void _error(BuildContext context, String location, String message) =>
      _log(context, "error", location, message);
  static void _debug(BuildContext context, String location, String message) =>
      _log(context, "debug", location, message);
  static void _warning(BuildContext context, String location, String message) =>
      _log(context, "warning", location, message);

  static void _log(
      BuildContext context, String level, String location, String message) {
    _logasync(context, level, location, message).then((value) => null);
  }

  static Future _logasync(BuildContext context, String level, String location,
      String message) async {
        return ;
    if (ApplicationConfiguration.instance == null) return;
    try {
      var uri =
          "${ApplicationConfiguration.instance!.webapipfs}/private/portailmobile/log/$level";
      debugPrint("logging $message to ${uri.toString()}");
      var response = await OAuthManager.of(context)?.post(context, uri,
          body: {
            "message": message,
            "version": "${packageInfo?.version}",
            "location": location,
            "buildNumber": "${packageInfo?.buildNumber}",
            "packageName": "${packageInfo?.packageName}",
            "appName": "${packageInfo?.appName}",
            "installerStore": "${packageInfo?.installerStore}",
            "buildSignature": "${packageInfo?.buildSignature}",
          });

      if (response.statusCode == 200) {
        debugPrint(response.body);
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
