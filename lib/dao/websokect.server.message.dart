import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/dao/prestationtache.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestationtacheaction.dao.dart';

class ServerMessageHandler {
  final String source;
  final dynamic message;
  ServerMessageHandler(this.source) : message = _fromJson(source);

  static dynamic _fromJson(String source) {
    try {
      var map = json.decode(source);
      //print(map['type'].toString() + map['data'].toString());

      if (map['type'] == 'PrestationTacheMessage') {
        return PrestationTacheMessage.fromMap(map['data']);
      }
      if (map['type'] == "PrestationTacheActionMessage") {
        return PrestationTacheActionMessage.fromMap(map['data']);
      }
      if (map['type'] == "PrestationTacheAction") {
        return PrestationTacheAction.fromMap(map['data']);
      }
      if (map['type'] == "PrestationTache") {
        return PrestationTache.fromMap(map['data']);
      }
      if (map['type'] == "WsError") {
        return WsError.fromMap(map['data']);
      }
      if (map['type'] == "WsProcessAlreadyRunning") {
        return WsProcessAlreadyRunning.fromMap(map['data']);
      }

      throw ("Unable to deserialise ${map['type']}");
    } catch (e) {
      FlutterError.reportError(FlutterErrorDetails(
          exception: e,
          library: "ServerMessageHandler._fromJson",
          context: ErrorDescription("_fromJson")));
    }
  }

  handlemessage({
    void Function(PrestationTacheMessage message)? prestationTacheMessage,
    Function(PrestationTacheActionMessage message)?
        prestationTacheActionMessage,
    Function(PrestationTacheAction message)? prestationTacheAction,
    Function(PrestationTache message)? prestationTache,
    Function(WsError message)? wsError,
    Function(WsProcessAlreadyRunning message)? wsProcessAlreadyRunning,
  }) {
    if (message is PrestationTacheMessage) {
      return prestationTacheMessage?.call(message);
    }
    if (message is PrestationTacheActionMessage) {
      return prestationTacheActionMessage?.call(message);
    }
    if (message is PrestationTacheAction) {
      return prestationTacheAction?.call(message);
    }
    if (message is PrestationTache) {
      return prestationTache?.call(message);
    }
    if (message is WsError) {
      return wsError?.call(message);
    }
    if (message is WsProcessAlreadyRunning) {
      return wsProcessAlreadyRunning?.call(message);
    }
  }
}

class PrestationTacheMessage extends Equatable {
  final String action;
  final String statut;
  final int tacheId;
  final int prestationTacheId;
  final int prestationId;
  const PrestationTacheMessage({
    required this.action,
    required this.statut,
    required this.tacheId,
    required this.prestationTacheId,
    required this.prestationId,
  });

  PrestationTacheMessage copyWith({
    String? action,
    String? statut,
    int? tacheId,
    int? prestationTacheId,
    int? prestationId,
  }) {
    return PrestationTacheMessage(
      action: action ?? this.action,
      statut: statut ?? this.statut,
      tacheId: tacheId ?? this.tacheId,
      prestationTacheId: prestationTacheId ?? this.prestationTacheId,
      prestationId: prestationId ?? this.prestationId,
    );
  }

  factory PrestationTacheMessage.fromMap(Map<String, dynamic> map) {
    return PrestationTacheMessage(
      action: map['action'] ?? '',
      statut: map['statut'] ?? '',
      tacheId: map['tacheId']?.toInt() ?? 0,
      prestationTacheId: map['prestationTacheId']?.toInt() ?? 0,
      prestationId: map['prestationId']?.toInt() ?? 0,
    );
  }

  factory PrestationTacheMessage.fromJson(String source) =>
      PrestationTacheMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PrestationTacheMessage(action: $action, statut: $statut, tacheId: $tacheId, prestationTacheId: $prestationTacheId, prestationId: $prestationId)';
  }

  @override
  List<Object> get props {
    return [
      action,
      statut,
      tacheId,
      prestationTacheId,
      prestationId,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'statut': statut,
      'tacheId': tacheId,
      'prestationTacheId': prestationTacheId,
      'prestationId': prestationId,
    };
  }

  String toJson() => json.encode(toMap());
}

class PrestationTacheActionMessage extends Equatable {
  final String action;
  final int actionId;
  final String label;
  final int prestationTacheActionId;
  final int prestationId;
  final String statut;
  final int prestationTacheId;
  const PrestationTacheActionMessage({
    required this.action,
    required this.actionId,
    required this.label,
    required this.prestationTacheActionId,
    required this.prestationId,
    required this.statut,
    required this.prestationTacheId,
  });

  PrestationTacheActionMessage copyWith({
    String? action,
    int? actionId,
    String? label,
    int? prestationTacheActionId,
    int? prestationId,
    String? statut,
    int? prestationTacheId,
  }) {
    return PrestationTacheActionMessage(
      action: action ?? this.action,
      actionId: actionId ?? this.actionId,
      label: label ?? this.label,
      prestationTacheActionId:
          prestationTacheActionId ?? this.prestationTacheActionId,
      prestationId: prestationId ?? this.prestationId,
      statut: statut ?? this.statut,
      prestationTacheId: prestationTacheId ?? this.prestationTacheId,
    );
  }

  factory PrestationTacheActionMessage.fromJson(String source) =>
      PrestationTacheActionMessage.fromMap(json.decode(source));

  @override
  List<Object> get props {
    return [
      action,
      actionId,
      label,
      prestationTacheActionId,
      prestationId,
      statut,
      prestationTacheId,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'actionId': actionId,
      'label': label,
      'prestationTacheActionId': prestationTacheActionId,
      'prestationId': prestationId,
      'statut': statut,
      'prestationTacheId': prestationTacheId,
    };
  }

  factory PrestationTacheActionMessage.fromMap(Map<String, dynamic> map) {
    return PrestationTacheActionMessage(
      action: map['action'] ?? '',
      actionId: map['actionId']?.toInt() ?? 0,
      label: map['label'] ?? '',
      prestationTacheActionId: map['prestationTacheActionId']?.toInt() ?? 0,
      prestationId: map['prestationId']?.toInt() ?? 0,
      statut: map['statut'] ?? '',
      prestationTacheId: map['prestationTacheId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'PrestationTacheActionMessage(action: $action, actionId: $actionId, label: $label, prestationTacheActionId: $prestationTacheActionId, prestationId: $prestationId, statut: $statut, prestationTacheId: $prestationTacheId)';
  }
}

class WsError extends Equatable {
  final String message;
  const WsError({
    required this.message,
  });

  WsError copyWith({
    String? message,
  }) {
    return WsError(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
    };
  }

  factory WsError.fromMap(Map<String, dynamic> map) {
    return WsError(
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WsError.fromJson(String source) =>
      WsError.fromMap(json.decode(source));

  @override
  String toString() => 'WsError(message: $message)';

  @override
  List<Object> get props => [message];
}

class WsProcessAlreadyRunning extends Equatable {
  final PrestationTache prestationTache;
  const WsProcessAlreadyRunning({
    required this.prestationTache,
  });

  WsProcessAlreadyRunning copyWith({
    PrestationTache? prestationTache,
  }) {
    return WsProcessAlreadyRunning(
      prestationTache: prestationTache ?? this.prestationTache,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prestationTache': prestationTache.toMap(),
    };
  }

  factory WsProcessAlreadyRunning.fromMap(Map<String, dynamic> map) {
    return WsProcessAlreadyRunning(
      prestationTache: PrestationTache.fromMap(map['prestationTache']),
    );
  }

  String toJson() => json.encode(toMap());

  factory WsProcessAlreadyRunning.fromJson(String source) =>
      WsProcessAlreadyRunning.fromMap(json.decode(source));

  @override
  String toString() =>
      'WsProcessAlreadyRunning(prestationTache: $prestationTache)';

  @override
  List<Object> get props => [prestationTache];
}
