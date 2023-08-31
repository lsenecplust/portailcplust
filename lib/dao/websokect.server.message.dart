import 'dart:convert';

import 'package:equatable/equatable.dart';

class MigWebSocketServerMessage extends Equatable {
  final String message;
  final bool error;
  const MigWebSocketServerMessage({
    required this.message,
    required this.error,
  });

  MigWebSocketServerMessage copyWith({
    String? message,
    bool? error,
  }) {
    return MigWebSocketServerMessage(
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Message': message,
      'Error': error,
    };
  }

  factory MigWebSocketServerMessage.fromMap(Map<String, dynamic> map) {
    return MigWebSocketServerMessage(
      message: map['Message'] ?? '',
      error: map['Error'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MigWebSocketServerMessage.fromJson(String source) => MigWebSocketServerMessage.fromMap(json.decode(source));

  @override
  String toString() => 'MigWebSocketServerMessage(message: $message, error: $error)';

  @override
  List<Object> get props => [message, error];
}
