import 'package:flutter/material.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/country_repository.dart';

class CountryProvider with ChangeNotifier {
  final CountryRepository repository;
  List<CountryEntity> countries = [];
  List<CountryEntity> filteredCountries = [];
  CountryEntity? selectedCountry;
  bool isLoading = false;
  String errorMessage = '';

  CountryProvider(this.repository);

  Future<void> fetchAllCountries() async {
    isLoading = true;
    notifyListeners();
    try {
      countries = await repository.getAllCountries();
      filteredCountries = countries;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterCountries(String query) {
    filteredCountries = countries.where((country) =>
        country.name.toLowerCase().contains(query.toLowerCase())).toList();
    notifyListeners();
  }

  Future<void> searchCountry(String name) async {
    isLoading = true;
    notifyListeners();
    try {
      selectedCountry = await repository.getCountryByName(name);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
