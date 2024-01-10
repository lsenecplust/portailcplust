// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:equatable/equatable.dart';

class PrestationTache extends Equatable {
  final int Id;
  final int TacheId;
  final int PrestationId;
  final DateTime DateDebut;
  final DateTime? DateFin;
  final String Operateur;
  final String Detail;
  final String Context;
  final String ContextJson;
  final String Input;
  final String Output;
  final String Statut;
  final String Log;
  const PrestationTache({
    required this.Id,
    required this.TacheId,
    required this.PrestationId,
    required this.DateDebut,
    this.DateFin,
    required this.Operateur,
    required this.Detail,
    required this.Context,
    required this.ContextJson,
    required this.Input,
    required this.Output,
    required this.Statut,
    required this.Log,
  });

  PrestationTache copyWith({
    int? Id,
    int? TacheId,
    int? PrestationId,
    DateTime? DateDebut,
    DateTime? DateFin,
    String? Operateur,
    String? Detail,
    String? Context,
    String? ContextJson,
    String? Input,
    String? Output,
    String? Statut,
    String? Log,
  }) {
    return PrestationTache(
      Id: Id ?? this.Id,
      TacheId: TacheId ?? this.TacheId,
      PrestationId: PrestationId ?? this.PrestationId,
      DateDebut: DateDebut ?? this.DateDebut,
      DateFin: DateFin ?? this.DateFin,
      Operateur: Operateur ?? this.Operateur,
      Detail: Detail ?? this.Detail,
      Context: Context ?? this.Context,
      ContextJson: ContextJson ?? this.ContextJson,
      Input: Input ?? this.Input,
      Output: Output ?? this.Output,
      Statut: Statut ?? this.Statut,
      Log: Log ?? this.Log,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'TacheId': TacheId,
      'PrestationId': PrestationId,
      'DateDebut': DateDebut.millisecondsSinceEpoch,
      'DateFin': DateFin?.millisecondsSinceEpoch,
      'Operateur': Operateur,
      'Detail': Detail,
      'Context': Context,
      'ContextJson': ContextJson,
      'Input': Input,
      'Output': Output,
      'Statut': Statut,
      'Log': Log,
    };
  }

  factory PrestationTache.fromMap(Map<String, dynamic> map) {
    return PrestationTache(
      Id: map['Id']?.toInt() ?? 0,
      TacheId: map['TacheId']?.toInt() ?? 0,
      PrestationId: map['PrestationId']?.toInt() ?? 0,
      DateDebut: DateTime.parse(map['DateDebut']),
      DateFin: map['DateFin'] != null ? DateTime.parse(map['DateFin']) : null,
      Operateur: map['Operateur'] ?? '',
      Detail: map['Detail'] ?? '',
      Context: map['Context'] ?? '',
      ContextJson: map['ContextJson'] ?? '',
      Input: map['Input'] ?? '',
      Output: map['Output'] ?? '',
      Statut: map['Statut'] ?? '',
      Log: map['Log'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PrestationTache.fromJson(String source) => PrestationTache.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PrestationTache(Id: $Id, TacheId: $TacheId, PrestationId: $PrestationId, DateDebut: $DateDebut, DateFin: $DateFin, Operateur: $Operateur, Detail: $Detail, Context: $Context, ContextJson: $ContextJson, Input: $Input, Output: $Output, Statut: $Statut, Log: $Log)';
  }

  @override
  List<Object> get props {
    return [
      Id,
      TacheId,
      PrestationId,
      DateDebut,
      DateFin ?? 1,
      Operateur,
      Detail,
      Context,
      ContextJson,
      Input,
      Output,
      Statut,
      Log,
    ];
  }
}
