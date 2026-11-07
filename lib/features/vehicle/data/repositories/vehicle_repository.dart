import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/base_vehicle_repository.dart';
import '../data_sources/vehicle_remote_data_source.dart';

class VehicleRepository implements BaseVehicleRepository {
  final BaseVehicleRemoteDataSource remoteDataSource;

  VehicleRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, Vehicle>> lookup(String registration) async {
    try {
      final vehicle = await remoteDataSource.lookup(registration);
      return Right(vehicle);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on http.ClientException {
      return const Left(NetworkFailure('Check your connection and try again'));
    } on SocketException {
      return const Left(NetworkFailure('Check your connection and try again'));
    } catch (_) {
      return const Left(UnknownFailure('Something went wrong'));
    }
  }
}
