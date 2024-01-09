import 'dart:convert';

import 'package:equatable/equatable.dart';

class MigWebSocketServerMessage extends Equatable {
  final String message;
  final bool error;
  final MigNotifiyPrestationTacheMessage? migNotifiyPrestationTacheMessage;
  final MigNotifiyPrestationTacheActionMessage?
      migNotifiyPrestationTacheActionMessage;
  const MigWebSocketServerMessage({
    required this.message,
    required this.error,
    this.migNotifiyPrestationTacheActionMessage,
    this.migNotifiyPrestationTacheMessage,
  });

  MigWebSocketServerMessage copyWith({
    String? message,
    bool? error,
    MigNotifiyPrestationTacheMessage? migNotifiyPrestationTacheMessage,
  }) {
    return MigWebSocketServerMessage(
      message: message ?? this.message,
      error: error ?? this.error,
      migNotifiyPrestationTacheMessage: migNotifiyPrestationTacheMessage ??
          this.migNotifiyPrestationTacheMessage,
    );
  }

  factory MigWebSocketServerMessage.fromMap(Map<String, dynamic> map) {
    return MigWebSocketServerMessage(
      message: map['ErrorMessage'] ?? '',
      error: map['error'] ?? false,
      migNotifiyPrestationTacheActionMessage:
          map['MigNotifiyPrestationTacheActionMessage'] != null
              ? MigNotifiyPrestationTacheActionMessage.fromMap(
                  map['MigNotifiyPrestationTacheActionMessage'])
              : null,
      migNotifiyPrestationTacheMessage:
          map['MigNotifiyPrestationTacheMessage'] != null
              ? MigNotifiyPrestationTacheMessage.fromMap(
                  map['MigNotifiyPrestationTacheMessage'])
              : null,
    );
  }

  factory MigWebSocketServerMessage.fromJson(String source) =>
      MigWebSocketServerMessage.fromMap(json.decode(source));

  @override
  String toString() =>
      'MigWebSocketServerMessage(message: $message, error: $error, migNotifiyPrestationTacheMessage: $migNotifiyPrestationTacheMessage)';

  @override
  List<Object> get props => [
        message,
        error,
        migNotifiyPrestationTacheMessage ?? 1,
        migNotifiyPrestationTacheActionMessage ?? 1
      ];
}

class MigNotifiyPrestationTacheMessage extends Equatable {
  final String action;
  final String statut;
  final int tacheid;
  final int prestationtacheid;
  final int prestationid;
  const MigNotifiyPrestationTacheMessage({
    required this.action,
    required this.statut,
    required this.tacheid,
    required this.prestationtacheid,
    required this.prestationid,
  });

  MigNotifiyPrestationTacheMessage copyWith({
    String? action,
    String? statut,
    int? tacheid,
    int? prestationtacheid,
    int? prestationid,
  }) {
    return MigNotifiyPrestationTacheMessage(
      action: action ?? this.action,
      statut: statut ?? this.statut,
      tacheid: tacheid ?? this.tacheid,
      prestationtacheid: prestationtacheid ?? this.prestationtacheid,
      prestationid: prestationid ?? this.prestationid,
    );
  }

  factory MigNotifiyPrestationTacheMessage.fromMap(Map<String, dynamic> map) {
    return MigNotifiyPrestationTacheMessage(
      action: map['action'] ?? '',
      statut: map['statut'] ?? '',
      tacheid: map['tache_id']?.toInt() ?? 0,
      prestationtacheid: map['prestation_tache_id']?.toInt() ?? 0,
      prestationid: map['prestation_id']?.toInt() ?? 0,
    );
  }

  factory MigNotifiyPrestationTacheMessage.fromJson(String source) =>
      MigNotifiyPrestationTacheMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MigNotifiyPrestationTacheMessage(action: $action, statut: $statut, tache_id: $tacheid, prestation_tache_id: $prestationtacheid, prestation_id: $prestationid)';
  }

  @override
  List<Object> get props {
    return [
      action,
      statut,
      tacheid,
      prestationtacheid,
      prestationid,
    ];
  }
}

class MigNotifiyPrestationTacheActionMessage extends Equatable {
  final String action;
  final int actionid;
  final String label;
  final int prestationtacheactionid;
  final String statut;
  final int prestationtacheid;
  const MigNotifiyPrestationTacheActionMessage({
    required this.action,
    required this.actionid,
    required this.label,
    required this.prestationtacheactionid,
    required this.statut,
    required this.prestationtacheid,
  });

  MigNotifiyPrestationTacheActionMessage copyWith({
    String? action,
    int? actionid,
    String? label,
    int? prestationtacheactionid,
    String? statut,
    int? prestationtacheid,
  }) {
    return MigNotifiyPrestationTacheActionMessage(
      action: action ?? this.action,
      actionid: actionid ?? this.actionid,
      label: label ?? this.label,
      prestationtacheactionid:
          prestationtacheactionid ?? this.prestationtacheactionid,
      statut: statut ?? this.statut,
      prestationtacheid: prestationtacheid ?? this.prestationtacheid,
    );
  }

  factory MigNotifiyPrestationTacheActionMessage.fromMap(
      Map<String, dynamic> map) {
    return MigNotifiyPrestationTacheActionMessage(
      action: map['action'] ?? '',
      actionid: map['action_id']?.toInt() ?? 0,
      label: map['label'] ?? '',
      prestationtacheactionid: map['prestation_tache_action_id']?.toInt() ?? 0,
      statut: map['statut'] ?? '',
      prestationtacheid: map['prestation_tache_id']?.toInt() ?? 0,
    );
  }

  factory MigNotifiyPrestationTacheActionMessage.fromJson(String source) =>
      MigNotifiyPrestationTacheActionMessage.fromMap(json.decode(source));

  @override
  List<Object> get props {
    return [
      action,
      actionid,
      label,
      prestationtacheactionid,
      statut,
      prestationtacheid,
    ];
  }
}
