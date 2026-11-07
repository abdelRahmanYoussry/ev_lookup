import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

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
}
