import 'package:flutter/material.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/country_repository.dart';

class CountryProvider with ChangeNotifier {
  final CountryRepository repository;
  List<CountryEntity> _countries = [];
  List<CountryEntity> _filteredCountries = [];
  bool _isLoading = false;
  String _errorMessage = '';

  CountryProvider(this.repository);

  List<CountryEntity> get filteredCountries => _filteredCountries;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCountries() async {
    _isLoading = true;
    notifyListeners();
    try {
      _countries = await repository.getAllCountries();
      _filteredCountries = _countries;
    } catch (e) {
      _errorMessage = 'Failed to load countries';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterCountries(String query) {
    _filteredCountries = _countries
        .where((country) =>
            country.commonName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
