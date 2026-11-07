import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/constants.dart';
import '../models/vehicle_model.dart';

abstract class BaseVehicleRemoteDataSource {
  Future<VehicleModel> lookup(String registration);
}

class VehicleRemoteDataSource implements BaseVehicleRemoteDataSource {
  final http.Client client;

  VehicleRemoteDataSource(this.client);

  @override
  Future<VehicleModel> lookup(String registration) async {
    final uri = Uri.parse(
      '$baseUrl/vehicles/lookup',
    ).replace(queryParameters: {'registration': registration});
    final response = await client.get(uri);

    switch (response.statusCode) {
      case 200:
        return VehicleModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      case 404:
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw NotFoundException(body['message'] as String);
      default:
        throw ServerException(response.statusCode);
    }
  }
}
