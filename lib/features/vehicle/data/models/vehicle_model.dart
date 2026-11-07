import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required super.id,
    required super.make,
    required super.model,
    required super.year,
    required super.batteryKwh,
    required super.connector,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      batteryKwh: (json['batteryKwh'] as num).toInt(),
      connector: json['connector'] as String,
    );
  }
}
