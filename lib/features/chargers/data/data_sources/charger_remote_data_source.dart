import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/constants.dart';
import '../models/charger_model.dart';

abstract class BaseChargerRemoteDataSource {
  Future<List<ChargerModel>> getChargers();
}

class ChargerRemoteDataSource implements BaseChargerRemoteDataSource {
  final http.Client client;

  ChargerRemoteDataSource(this.client);

  @override
  Future<List<ChargerModel>> getChargers() async {
    final response = await client.get(Uri.parse('$baseUrl/chargers'));

    switch (response.statusCode) {
      case 200:
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return (body['chargers'] as List)
            .map((json) => ChargerModel.fromJson(json as Map<String, dynamic>))
            .toList();
      case 404:
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw NotFoundException(body['message'] as String);
      default:
        throw ServerException(response.statusCode);
    }
  }
}
