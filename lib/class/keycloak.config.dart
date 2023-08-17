import 'package:equatable/equatable.dart';
import 'dart:convert';

class Keycloack extends Equatable {
  final String issuer;
  final String clientid;
  const Keycloack({
    required this.issuer,
    required this.clientid,
  });
  Uri get authorizationEndpoint =>
      Uri.parse("$issuer/protocol/openid-connect/auth");
  Uri get tokenEndpoint => Uri.parse("$issuer/protocol/openid-connect/token");
  Uri get logoutEndpoint => Uri.parse("$issuer/protocol/openid-connect/logout");


  factory Keycloack.fromMap(Map<String, dynamic> map) {
    return Keycloack(
      issuer: map['issuer'] ?? '',
      clientid: map['clientid'] ?? '',
    );
  }

  factory Keycloack.fromJson(String source) => Keycloack.fromMap(json.decode(source));

  @override
  String toString() => 'Keycloack(issuer: $issuer, clientid: $clientid)';

  @override
  List<Object> get props => [issuer, clientid];
}
