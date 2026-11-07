import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_compatible_chargers.dart';
import 'chargers_state.dart';

class ChargersCubit extends Cubit<ChargersState> {
  final GetCompatibleChargers _getCompatibleChargers;
  String? _connector;

  ChargersCubit(this._getCompatibleChargers) : super(const ChargersLoading());

  Future<void> load(String connector) async {
    _connector = connector;
    emit(const ChargersLoading());

    final result = await _getCompatibleChargers(connector);
    if (isClosed) return;

    emit(
      result.fold(
        (failure) => ChargersFailure(failure.message),
        (chargers) =>
            chargers.isEmpty ? const ChargersEmpty() : ChargersLoaded(chargers),
      ),
    );
  }

  Future<void> retry() async {
    final connector = _connector;
    if (connector == null || state is ChargersLoading) return;
    await load(connector);
  }
}
