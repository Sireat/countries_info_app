class CountryEntity {
  final String commonName;
  final String officialName;
  final String flag;
  final String capital;
  final String region;
  final List<String> languages;
  final String currency;
  final List<String> borders;
  final String mapsUrl;
  final String carSide;
  final String timezone;
  final double area;
  final int population;
  final String demonym;

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
