/// Represents a country entity with various attributes.
/// This class is used to encapsulate country data in a structured format.
class CountryEntity {
  /// The common name of the country (e.g., "United States").
  final String commonName;

  /// The official name of the country (e.g., "United States of America").
  final String officialName;

  /// The URL of the country's flag image (e.g., "https://flagcdn.com/us.png").
  final String flag;

  /// The capital city of the country (e.g., "Washington, D.C.").
  final String capital;

  /// The region where the country is located (e.g., "Americas").
  final String region;

  /// A list of languages spoken in the country (e.g., ["English"]).
  final List<String> languages;

  /// The name of the country's currency (e.g., "United States Dollar").
  final String currency;

  /// A list of bordering countries' codes (e.g., ["CAN", "MEX"]).
  final List<String> borders;

  /// The URL to the Google Maps location of the country (e.g., "https://goo.gl/maps/xyz").
  final String mapsUrl;

  /// The side of the road the country drives on (left or right) (e.g., "right").
  final String carSide;

  /// The primary timezone of the country (e.g., "America/New_York").
  final String timezone;

  /// The total area of the country in square kilometers (e.g., 9833517.0).
  final double area;

  /// The total population of the country (e.g., 331002651).
  final int population;

  /// The term used for the country's residents (e.g., "American").
  final String demonym;


  /// Constructor for creating a new instance of CountryEntity.
  CountryEntity({
    required this.commonName,
    required this.officialName,
    required this.flag,
    required this.capital,
    required this.region,
    required this.languages,
    required this.currency,
    required this.borders,
    required this.mapsUrl,
    required this.carSide,
    required this.timezone,
    required this.area,
    required this.population,
    required this.demonym,
  });
}
