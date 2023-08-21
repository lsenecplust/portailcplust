// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Scandit {
  final String licenseKey;

  Scandit({
    required this.licenseKey,
  });

  Scandit copyWith({
    String? licenseKey,
  }) {
    return Scandit(
      licenseKey: licenseKey ?? this.licenseKey,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'licenseKey': licenseKey,
    };
  }

  factory Scandit.fromMap(Map<String, dynamic> map) {
    return Scandit(
      licenseKey: map['licenseKey'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Scandit.fromJson(String source) => Scandit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Scandit(licenseKey: $licenseKey)';

  @override
  bool operator ==(covariant Scandit other) {
    if (identical(this, other)) return true;
  
    return 
      other.licenseKey == licenseKey;
  }

  @override
  int get hashCode => licenseKey.hashCode;
}
