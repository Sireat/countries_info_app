class CountryEntity {
  final String name;
  final String flag;
  final String region;
  final String capital;
  final int population;
  final String currency;
  final List<String> languages;
  final List<String> borders;

  CountryEntity({
    required this.name,
    required this.flag,
    required this.region,
    required this.capital,
    required this.population,
    required this.currency,
    required this.languages,
    required this.borders,
  });
}
