import '../../domain/entities/charger.dart';

class ChargerModel extends Charger {
  const ChargerModel({
    required super.id,
    required super.name,
    required super.connector,
    required super.powerKw,
    required super.freeBays,
    required super.totalBays,
    required super.minutes,
    required super.totalGbp,
  });

  factory ChargerModel.fromJson(Map<String, dynamic> json) {
    return ChargerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      connector: json['connector'] as String,
      powerKw: (json['powerKw'] as num).toInt(),
      freeBays: (json['freeBays'] as num).toInt(),
      totalBays: (json['totalBays'] as num).toInt(),
      minutes: (json['minutes'] as num).toInt(),
      totalGbp: (json['totalGbp'] as num).toDouble(),
    );
  }
}
