import '../../../../core/error/failure.dart'; // Imports the Failure class for error handling.
import '../../domain/entities/country_entity.dart'; // Imports the CountryEntity class from the domain layer.
import '../../domain/repositories/country_repository.dart'; // Imports the CountryRepository interface from the domain layer.
import '../datasources/country_remote_datasource.dart'; // Imports the CountryRemoteDataSource for remote data fetching.

/// Implementation of the CountryRepository interface.
/// Handles the communication between the domain layer and the remote data source.
class CountryRepositoryImpl implements CountryRepository {
  // Remote data source used to fetch country data from an external API.
  final CountryRemoteDataSource remoteDataSource;

  /// Constructor accepting a CountryRemoteDataSource instance.
  CountryRepositoryImpl(this.remoteDataSource);

  /// Fetches a list of all countries from the remote data source.
  /// Catches any exceptions thrown by the data source and wraps them in a ServerFailure.
  @override
  Future<List<CountryEntity>> getAllCountries() async {
    try {
      // Attempts to fetch all countries from the remote data source.
      final countries = await remoteDataSource.getAllCountries();
      return countries;
    } catch (e) {
      throw ServerFailure('Failed to fetch countries: ${e.toString()}');
    }
  }
  /// Fetches a specific country by its name from the remote data source.
  /// Catches any exceptions thrown by the data source and wraps them in a ServerFailure.
  @override
  Future<CountryEntity> getCountryByName(String name) async {
    try {
      // Attempts to fetch the country by name from the remote data source.
      final country = await remoteDataSource.getCountryByName(name);
      return country; // Returns the CountryEntity object if successful.
    } catch (e) {
      throw ServerFailure('Failed to fetch country by name: ${e.toString()}');
    }
  }
}