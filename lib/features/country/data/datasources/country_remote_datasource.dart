import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/country_entity.dart';
import '../models/country_model.dart';

abstract class CountryRemoteDataSource {
  Future<List<CountryEntity>> getAllCountries();
  Future<CountryEntity> getCountryByName(String name);
}

class CountryRemoteDataSourceImpl implements CountryRemoteDataSource {
  final http.Client client;

  CountryRemoteDataSourceImpl(this.client);

  @override
  Future<List<CountryEntity>> getAllCountries() async {
    final response = await client.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }

  @override
  Future<CountryEntity> getCountryByName(String name) async {
    final response = await client.get(Uri.parse('https://restcountries.com/v3.1/name/$name'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      if (jsonList.isNotEmpty) {
        final Map<String, dynamic> json = jsonList[0]; // Get the first item in the list
        return CountryModel.fromJson(json);
      } else {
        throw Exception('No country found with the name: $name');
      }
    } else {
      throw Exception('Failed to load country');
    }
  }
}
