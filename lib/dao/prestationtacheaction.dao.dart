// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:equatable/equatable.dart';

class PrestationTacheAction extends Equatable {
  final int Id;
  final int ActionId;
  final int PrestationTacheId;
  final DateTime DateDebut;
  final DateTime? DateFin;
  final String Operateur;
  final String Detail;
  final String Input;
  final String Output;
  final String Statut;
  final String Log;
  const PrestationTacheAction({
    required this.Id,
    required this.ActionId,
    required this.PrestationTacheId,
    required this.DateDebut,
    this.DateFin,
    required this.Operateur,
    required this.Detail,
    required this.Input,
    required this.Output,
    required this.Statut,
    required this.Log,
  });

  PrestationTacheAction copyWith({
    int? Id,
    int? ActionId,
    int? PrestationTacheId,
    DateTime? DateDebut,
    DateTime? DateFin,
    String? Operateur,
    String? Detail,
    String? Input,
    String? Output,
    String? Statut,
    String? Log,
  }) {
    return PrestationTacheAction(
      Id: Id ?? this.Id,
      ActionId: ActionId ?? this.ActionId,
      PrestationTacheId: PrestationTacheId ?? this.PrestationTacheId,
      DateDebut: DateDebut ?? this.DateDebut,
      DateFin: DateFin ?? this.DateFin,
      Operateur: Operateur ?? this.Operateur,
      Detail: Detail ?? this.Detail,
      Input: Input ?? this.Input,
      Output: Output ?? this.Output,
      Statut: Statut ?? this.Statut,
      Log: Log ?? this.Log,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'ActionId': ActionId,
      'PrestationTacheId': PrestationTacheId,
      'DateDebut': DateDebut.millisecondsSinceEpoch,
      'DateFin': DateFin?.millisecondsSinceEpoch,
      'Operateur': Operateur,
      'Detail': Detail,
      'Input': Input,
      'Output': Output,
      'Statut': Statut,
      'Log': Log,
    };
  }

  factory PrestationTacheAction.fromMap(Map<String, dynamic> map) {
    return PrestationTacheAction(
      Id: map['Id']?.toInt() ?? 0,
      ActionId: map['ActionId']?.toInt() ?? 0,
      PrestationTacheId: map['PrestationTacheId']?.toInt() ?? 0,
      DateDebut: DateTime.parse(map['DateDebut']),
      DateFin: map['DateFin'] != null
          ? DateTime.parse(map['DateFin'])
          : null,
      Operateur: map['Operateur'] ?? '',
      Detail: map['Detail'] ?? '',
      Input: map['Input'] ?? '',
      Output: map['Output'] ?? '',
      Statut: map['Statut'] ?? '',
      Log: map['Log'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PrestationTacheAction.fromJson(String source) =>
      PrestationTacheAction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PrestationTacheAction(Id: $Id, ActionId: $ActionId, PrestationTacheId: $PrestationTacheId, DateDebut: $DateDebut, DateFin: $DateFin, Operateur: $Operateur, Detail: $Detail, Input: $Input, Output: $Output, Statut: $Statut, Log: $Log)';
  }

  @override
  List<Object> get props {
    return [
      Id,
      ActionId,
      PrestationTacheId,
      DateDebut,
      DateFin ?? 1,
      Operateur,
      Detail,
      Input,
      Output,
      Statut,
      Log,
    ];
  }
}
