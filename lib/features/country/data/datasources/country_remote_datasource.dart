import '../models/country_model.dart';
import 'dart:convert';
import 'package:countries_info_app/core/error/failure.dart';
import 'package:countries_info_app/core/utils/constants.dart';
import 'package:http/http.dart' as http;

abstract class CountryRemoteDataSource {
  Future<List<CountryModel>> getAllCountries();
  Future<CountryModel> getCountryByName(String name);
}

class CountryRemoteDataSourceImpl implements CountryRemoteDataSource {
  final http.Client client;

  CountryRemoteDataSourceImpl(this.client);

  @override
  Future<List<CountryModel>> getAllCountries() async {
    final response = await client.get(Uri.parse('${ApiConstants.baseUrl}/all'));

    if (response.statusCode == 200) {
      final List<dynamic> countriesJson = json.decode(response.body);
      return countriesJson.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      throw ServerFailure('Failed to load countries');
    }
  }

  @override
  Future<CountryModel> getCountryByName(String name) async {
    final response = await client.get(Uri.parse('${ApiConstants.baseUrl}/name/$name'));

    if (response.statusCode == 200) {
      final List<dynamic> countriesJson = json.decode(response.body);
      return CountryModel.fromJson(countriesJson.first);
    } else {
      throw ServerFailure('Country not found');
    }
  }
}
