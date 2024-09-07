import 'package:countries_info_app/core/error/failure.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/country_repository.dart';
import '../datasources/country_remote_datasource.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDataSource remoteDataSource;

  CountryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CountryEntity>> getAllCountries() async {
    try {
      return await remoteDataSource.getAllCountries();
    } on ServerFailure catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<CountryEntity> getCountryByName(String name) async {
    try {
      return await remoteDataSource.getCountryByName(name);
    } on ServerFailure catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
