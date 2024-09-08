import '../../../../core/error/failure.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/country_repository.dart';
import '../datasources/country_remote_datasource.dart';


class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDataSource remoteDataSource;

  CountryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CountryEntity>> getAllCountries() async {
    try {
      final countries = await remoteDataSource.getAllCountries();
      return countries;
    } catch (e) {
      throw ServerFailure('Failed to fetch countries: ${e.toString()}');
    }
  }

  @override
  Future<CountryEntity> getCountryByName(String name) async {
    try {
      final country = await remoteDataSource.getCountryByName(name);
      return country;
    } catch (e) {
      throw ServerFailure('Failed to fetch country by name: ${e.toString()}');
    }
  }
}
