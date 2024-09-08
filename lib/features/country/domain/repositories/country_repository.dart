import '../entities/country_entity.dart'; 

/// An abstract class defining the contract for a country repository.
/// This repository is responsible for fetching country data from a data source.
/// It abstracts the data retrieval logic, allowing the implementation to vary.
abstract class CountryRepository {
  /// Fetches a list of all countries.
  /// Returns a [Future] that resolves to a list of [CountryEntity] objects.
  /// This method is used to get data about all countries.
  Future<List<CountryEntity>> getAllCountries();

  /// Fetches a specific country by its name.
  /// Returns a [Future] that resolves to a [CountryEntity] object representing the country.
  /// Takes a [String] parameter [name] which is the name of the country to fetch.
  /// This method is used to get data about a specific country based on its name.
  Future<CountryEntity> getCountryByName(String name);
}