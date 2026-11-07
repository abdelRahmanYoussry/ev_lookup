import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/chargers/data/data_sources/charger_remote_data_source.dart';
import '../../features/chargers/data/repositories/charger_repository.dart';
import '../../features/chargers/domain/repositories/base_charger_repository.dart';
import '../../features/chargers/domain/use_cases/get_compatible_chargers.dart';
import '../../features/vehicle/data/data_sources/vehicle_remote_data_source.dart';
import '../../features/vehicle/data/repositories/vehicle_repository.dart';
import '../../features/vehicle/domain/repositories/base_vehicle_repository.dart';
import '../../features/vehicle/domain/use_cases/lookup_vehicle.dart';
import '../../mock/mock_transport.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<http.Client>(
    () => MockTransport(
      failLookupOnce: const bool.fromEnvironment('FAIL_LOOKUP_ONCE'),
      failChargersOnce: const bool.fromEnvironment('FAIL_CHARGERS_ONCE'),
      emptyChargers: const bool.fromEnvironment('EMPTY_CHARGERS'),
    ),
  );

  sl.registerLazySingleton<BaseVehicleRemoteDataSource>(
    () => VehicleRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<BaseVehicleRepository>(
    () => VehicleRepository(sl()),
  );
  sl.registerLazySingleton(() => LookupVehicle(sl()));

  sl.registerLazySingleton<BaseChargerRemoteDataSource>(
    () => ChargerRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<BaseChargerRepository>(
    () => ChargerRepository(sl()),
  );
  sl.registerLazySingleton(() => GetCompatibleChargers(sl()));
}
