
import '../entities/country_entity.dart';

abstract class CountryRepository {
  Future<List<CountryEntity>> getAllCountries();
  Future<CountryEntity> getCountryByName(String name);
}
