import 'package:equatable/equatable.dart';

class Charger extends Equatable {
  final String id;
  final String name;
  final String connector;
  final int powerKw;
  final int freeBays;
  final int totalBays;
  final int minutes;
  final double totalGbp;

  const Charger({
    required this.id,
    required this.name,
    required this.connector,
    required this.powerKw,
    required this.freeBays,
    required this.totalBays,
    required this.minutes,
    required this.totalGbp,
  });

  @override
  List<Object> get props => [
        id,
        name,
        connector,
        powerKw,
        freeBays,
        totalBays,
        minutes,
        totalGbp,
      ];
}
