import '../../domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  CountryModel({
    required String commonName,
    required String officialName,
    required String flag,
    required String capital,
    required String region,
    required List<String> languages,
    required String currency,
    required List<String> borders,
    required String mapsUrl,
    required String carSide,
    required String timezone,
    required double area,
    required int population,
    required String demonym,
  }) : super(
          commonName: commonName,
          officialName: officialName,
          flag: flag,
          capital: capital,
          region: region,
          languages: languages,
          currency: currency,
          borders: borders,
          mapsUrl: mapsUrl,
          carSide: carSide,
          timezone: timezone,
          area: area,
          population: population,
          demonym: demonym,
        );

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final commonName = json['name']['common'] ?? 'N/A';
    final officialName = json['name']['official'] ?? 'N/A';
    final flag = json['flags']['png'] ?? '';
    final capital = (json['capital'] as List<dynamic>? ?? []).isNotEmpty
        ? json['capital'][0] 
        : 'N/A';
    final region = json['region'] ?? 'N/A';
    final languages = (json['languages'] as Map<String, dynamic>?)
        ?.values
        .map((lang) => lang as String)
        .toList() ?? [];
    final currency = (json['currencies'] as Map<String, dynamic>?)
        ?.values
        .map((curr) => curr['name'] as String)
        .first ?? 'N/A';
    final borders = (json['borders'] as List<dynamic>? ?? []).cast<String>();
    final mapsUrl = json['maps']?['googleMaps'] ?? 'N/A';
    final carSide = json['car']?['side'] ?? 'N/A';
    final timezone = (json['timezones'] as List<dynamic>? ?? []).isNotEmpty
        ? json['timezones'][0] 
        : 'N/A';
    final area = (json['area'] as num?)?.toDouble() ?? 0.0;
    final population = json['population'] ?? 0;
    final demonym = json['demonyms']?['eng']?['m'] ?? 'N/A';

    return CountryModel(
      commonName: commonName,
      officialName: officialName,
      flag: flag,
      capital: capital,
      region: region,
      languages: languages,
      currency: currency,
      borders: borders,
      mapsUrl: mapsUrl,
      carSide: carSide,
      timezone: timezone,
      area: area,
      population: population,
      demonym: demonym,
    );
  }
}
