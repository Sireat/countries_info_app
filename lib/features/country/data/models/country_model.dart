import '../../domain/entities/country_entity.dart'; // Imports the CountryEntity class from the domain layer.

/// A data model class representing a country, extending the CountryEntity.
/// This class handles the transformation from JSON data to a CountryEntity object.
class CountryModel extends CountryEntity {
  /// Constructor for CountryModel that initializes all properties inherited from CountryEntity.
  CountryModel({
    required super.commonName, 
    required super.officialName, 
    required super.flag,
    required super.capital,
    required super.region, 
    required super.languages,
    required super.currency, 
    required super.borders, 
    required super.mapsUrl, 
    required super.carSide,
    required super.timezone, 
    required super.area, 
    required super.population, 
    required super.demonym,
    
  });

  /// Factory method to create a CountryModel from JSON data.
  /// Parses the JSON fields and converts them into the corresponding properties of CountryModel.
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
        .toList() 
        ?? [];
    final currency = (json['currencies'] as Map<String, dynamic>?)
        ?.values
        .map((curr) => curr['name'] as String)
        .first 
        ?? 'N/A';
    final borders = (json['borders'] as List<dynamic>? ?? []).cast<String>(); 
    final mapsUrl = json['maps']?['googleMaps'] ?? 'N/A';
    final carSide = json['car']?['side'] ?? 'N/A';
    final timezone = (json['timezones'] as List<dynamic>? ?? []).isNotEmpty
        ? json['timezones'][0] 
        : 'N/A';
    final area = (json['area'] as num?)?.toDouble() ?? 0.0;
    final population = json['population'] ?? 0;
    final demonym = json['demonyms']?['eng']?['m'] ?? 'N/A';
    
    // Returns an instance of CountryModel with the extracted data.
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
