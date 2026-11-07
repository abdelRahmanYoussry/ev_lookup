import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/registration_normalizer.dart';
import '../../domain/use_cases/lookup_vehicle.dart';
import 'vehicle_lookup_state.dart';

class VehicleLookupCubit extends Cubit<VehicleLookupState> {
  final LookupVehicle _lookupVehicle;
  String? _lastRegistration;

  VehicleLookupCubit(this._lookupVehicle) : super(const VehicleLookupInitial());

  Future<void> lookup(String raw) async {
    if (state is VehicleLookupLoading) return;

    final registration = RegistrationNormalizer.normalize(raw);
    if (registration.isEmpty) {
      emit(const VehicleLookupValidationError('Enter your registration'));
      return;
    }
    await _submit(registration);
  }

  Future<void> retry() async {
    final registration = _lastRegistration;
    if (registration == null || state is VehicleLookupLoading) return;
    await _submit(registration);
  }

  void reset() {
    _lastRegistration = null;
    emit(const VehicleLookupInitial());
  }

  Future<void> _submit(String registration) async {
    _lastRegistration = registration;
    emit(const VehicleLookupLoading());

    final result = await _lookupVehicle(registration);
    if (isClosed) return;

    emit(
      result.fold(
        (failure) => switch (failure) {
          NotFoundFailure() => VehicleLookupNotFound(failure.message),
          NetworkFailure() ||
          UnknownFailure() =>
            VehicleLookupFailed(failure.message),
        },
        (vehicle) => VehicleLookupSuccess(vehicle, registration),
      ),
    );
  }
}
