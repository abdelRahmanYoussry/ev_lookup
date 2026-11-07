import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/chargers/presentation/cubit/chargers_cubit.dart';
import '../../features/chargers/presentation/screens/charger_list_screen.dart';
import '../../features/vehicle/presentation/cubit/vehicle_lookup_cubit.dart';
import '../../features/vehicle/presentation/cubit/vehicle_lookup_state.dart';
import '../../features/vehicle/presentation/screens/confirmation_screen.dart';
import '../../features/vehicle/presentation/screens/registration_screen.dart';
import '../di/services_locator.dart';

abstract final class AppRoutes {
  static const registration = '/';
  static const confirmation = '/confirmation';
  static const chargers = '/chargers';
}

abstract final class AppRouter {
  static Route<void> onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      AppRoutes.confirmation => _confirmation(settings.arguments),
      AppRoutes.chargers => _chargers(settings.arguments),
      _ => BlocProvider(
          create: (_) => sl<VehicleLookupCubit>(),
          child: const RegistrationScreen(),
        ),
    };
    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  static Widget _confirmation(Object? arguments) {
    final success = arguments as VehicleLookupSuccess;
    return ConfirmationScreen(
      vehicle: success.vehicle,
      registration: success.registration,
    );
  }

  static Widget _chargers(Object? arguments) {
    final connector = arguments as String;
    return BlocProvider(
      create: (_) => sl<ChargersCubit>()..load(connector),
      child: const ChargerListScreen(),
    );
  }
}
