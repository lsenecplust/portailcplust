import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';

class MigWebSocketClientMessage extends Equatable {
  final String prestationRef;
  final String codeTache;
  final String offre;
  final Equipement? nouvelEquipement;
  final Equipement? ancienEquipement;
  const MigWebSocketClientMessage({
    required this.prestationRef,
    required this.codeTache,
    required this.offre,
    this.nouvelEquipement,
    this.ancienEquipement,
  });

  MigWebSocketClientMessage copyWith({
    String? prestationRef,
    String? codeTache,
    String? offre,
    Equipement? nouvelEquipement,
    Equipement? ancienEquipement,
  }) {
    return MigWebSocketClientMessage(
      prestationRef: prestationRef ?? this.prestationRef,
      codeTache: codeTache ?? this.codeTache,
      offre: offre ?? this.offre,
      nouvelEquipement: nouvelEquipement ?? this.nouvelEquipement,
      ancienEquipement: ancienEquipement ?? this.ancienEquipement,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prestationRef': prestationRef,
      'CodeTache': codeTache,
      'Offre': offre,
      'nouvelEquipement': nouvelEquipement?.toMap(),
      'ancienEquipement': ancienEquipement?.toMap(),
    };
  }

  factory MigWebSocketClientMessage.fromMap(Map<String, dynamic> map) {
    return MigWebSocketClientMessage(
      prestationRef: map['prestationRef'] ?? '',
      codeTache: map['CodeTache'] ?? '',
      offre: map['Offre'] ?? '',
      nouvelEquipement: map['nouvelEquipement'] != null ? Equipement.fromMap(map['nouvelEquipement']) : null,
      ancienEquipement: map['ancienEquipement'] != null ? Equipement.fromMap(map['ancienEquipement']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MigWebSocketClientMessage.fromJson(String source) => MigWebSocketClientMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MigWebSocketClientMessage(prestationRef: $prestationRef, codeTache: $codeTache, offre: $offre, nouvelEquipement: $nouvelEquipement, ancienEquipement: $ancienEquipement)';
  }

  @override
  List<Object> get props {
    return [
      prestationRef,
      codeTache,
      offre,
      nouvelEquipement ?? 1,
      ancienEquipement ?? 1,
    ];
  }
}
