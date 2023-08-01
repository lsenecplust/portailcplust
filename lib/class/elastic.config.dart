import 'dart:convert';
import 'package:flutter/foundation.dart';

class Elastic {
  final String index;
  final List<String> nodes;
  Elastic({
    required this.index,
    required this.nodes,
  });

  Elastic copyWith({
    String? index,
    List<String>? nodes,
  }) {
    return Elastic(
      index: index ?? this.index,
      nodes: nodes ?? this.nodes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'nodes': nodes,
    };
  }

  factory Elastic.fromMap(Map<String, dynamic> map) {
    return Elastic(
        index: map['index'] as String,
        nodes: List<String>.from(
          (map['nodes'].cast<String>()),
        ));
  }

  String toJson() => json.encode(toMap());

  factory Elastic.fromJson(String source) =>
      Elastic.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Elastic(index: $index, nodes: $nodes)';

  @override
  bool operator ==(covariant Elastic other) {
    if (identical(this, other)) return true;

    return other.index == index && listEquals(other.nodes, nodes);
  }

  @override
  int get hashCode => index.hashCode ^ nodes.hashCode;
}
