import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum EnumMigAction {
  affectation(Icons.switch_access_shortcut_outlined),
  restitution(Icons.settings_backup_restore_rounded),
  echange(Icons.swap_calls_rounded);

  final IconData icon;
  const EnumMigAction(
    this.icon,
  );
}

class MigAction extends Equatable {
  final String tache;
  final String codeTache;
  final bool isExecutable;
  const MigAction({
    required this.tache,
    required this.codeTache,
    required this.isExecutable,
  });

  EnumMigAction? get type => switch (codeTache) {
        'T0011' || 'T0012' => EnumMigAction.echange,
        'T0013' || 'T0010' => EnumMigAction.affectation,
        'T0040' || 'T0041' => EnumMigAction.restitution,
        _ => null
      };

  MigAction copyWith({
    String? tache,
    String? codeTache,
    bool? isExecutable,
  }) {
    return MigAction(
      tache: tache ?? this.tache,
      codeTache: codeTache ?? this.codeTache,
      isExecutable: isExecutable ?? this.isExecutable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tache': tache,
      'codeTache': codeTache,
      'isExecutable': isExecutable,
    };
  }

  factory MigAction.fromMap(Map<String, dynamic> map) {
    return MigAction(
      tache: map['tache'] ?? '',
      codeTache: map['codeTache'] ?? '',
      isExecutable: map['isExecutable'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MigAction.fromJson(String source) =>
      MigAction.fromMap(json.decode(source));

  @override
  String toString() =>
      'MigAction(tache: $tache, codeTache: $codeTache, isExecutable: $isExecutable)';

  @override
  bool operator ==(covariant MigAction other) {
    if (identical(this, other)) return true;

    return other.tache == tache && other.isExecutable == isExecutable;
  }

  @override
  int get hashCode => tache.hashCode ^ isExecutable.hashCode;

  @override
  List<Object> get props => [tache, codeTache, isExecutable];
}
