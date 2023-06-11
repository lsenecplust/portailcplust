import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:portail_canalplustelecom_mobile/class/keycloak.dart';
import 'package:flutter/services.dart' show rootBundle;

class ApplicationConfiguration extends Equatable {
  final String webapipfs;
  final Keycloack keycloak;

  static ApplicationConfiguration? instance;
  const ApplicationConfiguration({
    required this.webapipfs,
    required this.keycloak,
  });
  static init({String? environement}) async {
 
    var input = await rootBundle.loadString("appconfig.json");
    var map = jsonDecode(input);
    instance =
        ApplicationConfiguration.fromMap(map[environement ?? "production"]);
  }

  static setlocal() => init(environement: "local");
  static setdevelopment() => init(environement: "development");
  static setrecette() => init(environement: "recette");
  static setproduction() => init(environement: "production");

  factory ApplicationConfiguration.fromMap(Map<String, dynamic> map) {
    return ApplicationConfiguration(
      webapipfs: map['webapipfs'] ?? '',
      keycloak: Keycloack.fromMap(map['keycloak']),
    );
  }

  factory ApplicationConfiguration.fromJson(String source) =>
      ApplicationConfiguration.fromMap(json.decode(source));

  @override
  String toString() =>
      'ApplicationConfiguration(webapipfs: $webapipfs, keycloak: $keycloak)';

  @override
  List<Object> get props => [webapipfs, keycloak];
}
