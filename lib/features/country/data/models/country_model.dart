
import '../../domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  CountryModel({
    required super.name,
    required super.flag,
    required super.region,
    required super.capital,
    required super.population,
    required super.currency,
    required super.languages,
    required super.borders,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name']['common'],
      flag: json['flags']['png'],
      region: json['region'],
      capital: (json['capital'] as List).isNotEmpty ? json['capital'][0] : 'N/A',
      population: json['population'],
      currency: (json['currencies'] as Map).keys.first,
      languages: (json['languages'] as Map).values.map((lang) => lang as String).toList(),
      borders: (json['borders'] ?? []).cast<String>(),
    );
  }
}
