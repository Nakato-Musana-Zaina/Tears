// lib/models/healer_model.dart

class HealerModel {
  final int id;
  final String name;
  final String specialty;
  final int contact;

  HealerModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.contact,
  });

  factory HealerModel.fromJson(Map<String, dynamic> json) {
    return HealerModel(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      contact: json['contact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'contact': contact,
    };
  }
}