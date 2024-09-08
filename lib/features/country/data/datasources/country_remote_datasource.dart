import 'dart:convert'; // Provides JSON encoding and decoding functionality.
import 'package:http/http.dart' as http; // HTTP client for making network requests.
import '../../../../core/error/exceptions.dart'; // Custom exceptions for handling errors.
import '../../../../core/utils/constants.dart'; // Contains constant values like API endpoints and error messages.
import '../../domain/entities/country_entity.dart'; // Defines the CountryEntity used by the domain layer.
import '../models/country_model.dart'; // Defines the CountryModel used to convert JSON data to domain entities.

/// Abstract class defining the contract for fetching country data remotely.
abstract class CountryRemoteDataSource {
  /// Fetches a list of all countries from the remote server.
  Future<List<CountryEntity>> getAllCountries();

  /// Fetches a specific country by its name from the remote server.
  Future<CountryEntity> getCountryByName(String name);
}

/// Implementation of the CountryRemoteDataSource interface.
class CountryRemoteDataSourceImpl implements CountryRemoteDataSource {
  // HTTP client used to make requests to the server.
  final http.Client client;

  /// Constructor accepting an HTTP client to make network requests.
  CountryRemoteDataSourceImpl(this.client);

  /// Fetches a list of all countries from the remote server.
  /// Returns a list of CountryEntity if successful.
  /// Throws a ServerException if the request fails.
  @override
  Future<List<CountryEntity>> getAllCountries() async {
    // Make a GET request to fetch all countries with a timeout duration.
    final response = await client
        .get(Uri.parse(ALL_COUNTRIES_ENDPOINT))
        .timeout(REQUEST_TIMEOUT);

    // Check if the response status code is 200 (OK).
    if (response.statusCode == 200) {
      // Decode the JSON response into a list of dynamic objects.
      final List<dynamic> jsonList = json.decode(response.body);
      
      // Convert each JSON object into a CountryModel and then into CountryEntity.
      return jsonList.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      // Throw a ServerException if the response is not successful.
      throw ServerException(message: SERVER_FAILURE_MESSAGE);
    }
  }

  /// Fetches a specific country by its name from the remote server.
  /// Returns a CountryEntity if the country is found.
  /// Throws a ServerException if the request fails or the country is not found.
  @override
  Future<CountryEntity> getCountryByName(String name) async {
    // Make a GET request to fetch the country by its name with a timeout duration.
    final response = await client
        .get(Uri.parse('$COUNTRY_BY_NAME_ENDPOINT$name'))
        .timeout(REQUEST_TIMEOUT);

    // Check if the response status code is 200 (OK).
    if (response.statusCode == 200) {
      // Decode the JSON response into a list of dynamic objects.
      final List<dynamic> jsonList = json.decode(response.body);

      // Check if the list is not empty, indicating a country was found.
      if (jsonList.isNotEmpty) {
        // Convert the first JSON object into a CountryModel and then into CountryEntity.
        final Map<String, dynamic> json = jsonList[0];
        return CountryModel.fromJson(json);
      } else {
        // Throw a ServerException if no country matches the given name.
        throw ServerException(message: 'No country found with the name: $name');
      }
    } else {
      // Throw a ServerException if the response is not successful.
      throw ServerException(message: SERVER_FAILURE_MESSAGE);
    }
  }
}
