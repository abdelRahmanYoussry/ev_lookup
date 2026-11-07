import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final String id;
  final String make;
  final String model;
  final int year;
  final int batteryKwh;
  final String connector;

  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.batteryKwh,
    required this.connector,
  });

  @override
  List<Object> get props => [id, make, model, year, batteryKwh, connector];
}
