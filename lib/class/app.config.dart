import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:portail_canalplustelecom_mobile/class/log.dart';
import 'package:portail_canalplustelecom_mobile/class/scandit.config.dart';
import 'package:librairies/keycloack_auth.dart';

class ApplicationConfiguration extends Equatable {
  final String webapipfs;
  final KeycloakConfig keycloakConfig;
  final Scandit scandit;
  final bool speedAnimations;
  static ApplicationConfiguration? instance;
  const ApplicationConfiguration(
      {required this.webapipfs,
      required this.keycloakConfig,
      required this.scandit,
      this.speedAnimations = false});
  static init({String? environement,bool? speedAnimations}) async {
    var input = await rootBundle.loadString("appconfig.json");
    var map = jsonDecode(input);
    instance =
        ApplicationConfiguration.fromMap(map[environement ?? "production"]);
    Log.init();
  }

  static setlocal() => init(environement: "local");
  static setdevelopment() => init(environement: "development");
  static setrecette() => init(environement: "recette");
  static setproduction() => init(environement: "production");

  factory ApplicationConfiguration.fromMap(Map<String, dynamic> map) {
    return ApplicationConfiguration(
      webapipfs: map['webapipfs'] ?? '',
      keycloakConfig: KeycloakConfig.fromMap(map['keycloak']),
      scandit: Scandit.fromMap(map['scandit']),
      speedAnimations: true,
    );
  }

  factory ApplicationConfiguration.fromJson(String source) =>
      ApplicationConfiguration.fromMap(json.decode(source));

  @override
  String toString() =>
      'ApplicationConfiguration(webapipfs: $webapipfs, keycloak: $keycloakConfig)';

  @override
  List<Object> get props => [webapipfs, keycloakConfig];
}
