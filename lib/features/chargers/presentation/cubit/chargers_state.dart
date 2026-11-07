import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/charger.dart';

sealed class ChargersState extends Equatable {
  const ChargersState();

  @override
  List<Object?> get props => [];
}

class ChargersLoading extends ChargersState {
  const ChargersLoading();
}

class ChargersLoaded extends ChargersState {
  final List<Charger> chargers;
  const ChargersLoaded(this.chargers);

  @override
  List<Object?> get props => [chargers];
}

class ChargersEmpty extends ChargersState {
  const ChargersEmpty();
}

class ChargersFailure extends ChargersState {
  final Failure failure;
  const ChargersFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
