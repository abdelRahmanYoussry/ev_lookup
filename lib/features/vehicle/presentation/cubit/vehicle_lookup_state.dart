import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
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
  const VehicleLookupValidationError();
}

class VehicleLookupLoading extends VehicleLookupState {
  const VehicleLookupLoading();
}

class VehicleLookupNotFound extends VehicleLookupState {
  const VehicleLookupNotFound();
}

class VehicleLookupFailed extends VehicleLookupState {
  final Failure failure;
  const VehicleLookupFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}

class VehicleLookupSuccess extends VehicleLookupState {
  final Vehicle vehicle;
  final String registration;
  const VehicleLookupSuccess(this.vehicle, this.registration);

  @override
  List<Object?> get props => [vehicle, registration];
}
