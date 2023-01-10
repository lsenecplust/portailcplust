import 'dart:convert';

import 'package:flutter/material.dart';

enum EnumMigAction {
  affectationONT("T0013", "affectation-ont","Affectation ONT",Icons.router),
  affectationCPE("T0010", "affectation-cpe","Affectation CPE",Icons.switch_access_shortcut_outlined),
  restitutionONT("T0041", "restitution-ont","Restitution ONT",Icons.router),
  restitutionCPE("T0040", "restitution-cpe","Restitution CPE",Icons.switch_access_shortcut_outlined);

  final String code;
  final String libelle;
  final String displayName;
  final IconData icon;
  const EnumMigAction(this.code, this.libelle,this.displayName,this.icon);
}

class MigAction {
  final EnumMigAction tache;
  final bool isExecutable;
  MigAction({
    required this.tache,
    required this.isExecutable,
  });

  MigAction copyWith({
    EnumMigAction? tache,
    bool? isExecutable,
  }) {
    return MigAction(
      tache: tache ?? this.tache,
      isExecutable: isExecutable ?? this.isExecutable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codeTache': tache.code,
      'tache': tache.libelle,
      'isExecutable': isExecutable,
    };
  }

  factory MigAction.fromMap(Map<String, dynamic> map) {
    return MigAction(
      tache: EnumMigAction.values.firstWhere((e) => e.code == map['codeTache']),
      isExecutable: map['isExecutable'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MigAction.fromJson(String source) =>
      MigAction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Action(tache: $tache, isExecutable: $isExecutable)';

  @override
  bool operator ==(covariant MigAction other) {
    if (identical(this, other)) return true;

    return other.tache == tache && other.isExecutable == isExecutable;
  }

  @override
  int get hashCode => tache.hashCode ^ isExecutable.hashCode;
}
