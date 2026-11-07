import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/charger.dart';
import '../../domain/repositories/base_charger_repository.dart';
import '../data_sources/charger_remote_data_source.dart';

class ChargerRepository implements BaseChargerRepository {
  final BaseChargerRemoteDataSource remoteDataSource;

  ChargerRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Charger>>> getChargers() async {
    try {
      final chargers = await remoteDataSource.getChargers();
      return Right(chargers);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on http.ClientException {
      return const Left(NetworkFailure());
    } on SocketException {
      return const Left(NetworkFailure());
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
