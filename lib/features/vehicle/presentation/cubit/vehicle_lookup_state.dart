import 'package:equatable/equatable.dart';

import '../../domain/entities/vehicle.dart';

sealed class VehicleLookupState extends Equatable {
  const VehicleLookupState();

  @override
  List<Object?> get props => [];
}

class VehicleLookupInitial extends VehicleLookupState {
  const VehicleLookupInitial();
}

class VehicleLookupValidationError extends VehicleLookupState {
  final String message;
  const VehicleLookupValidationError(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleLookupLoading extends VehicleLookupState {
  const VehicleLookupLoading();
}

class VehicleLookupNotFound extends VehicleLookupState {
  final String message;
  const VehicleLookupNotFound(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleLookupFailed extends VehicleLookupState {
  final String message;
  const VehicleLookupFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleLookupSuccess extends VehicleLookupState {
  final Vehicle vehicle;
  final String registration;
  const VehicleLookupSuccess(this.vehicle, this.registration);

  @override
  List<Object?> get props => [vehicle, registration];
}
