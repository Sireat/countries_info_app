import 'package:flutter/material.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/country_repository.dart';

class CountryProvider with ChangeNotifier {
  final CountryRepository repository;
  List<CountryEntity> _countries = [];
  List<CountryEntity> _filteredCountries = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedRegion = 'All'; // Default to 'All'
  String _selectedQuery = '';

  CountryProvider(this.repository);

  List<CountryEntity> get filteredCountries => _filteredCountries;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedRegion => _selectedRegion; // Add getter

  Future<void> fetchCountries() async {
    _isLoading = true;
    notifyListeners();
    try {
      _countries = await repository.getAllCountries();
      _filteredCountries = _countries;
      _applyFilters();
    } catch (e) {
      _errorMessage = 'Failed to load countries';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterCountries(String query) {
    _selectedQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByRegion(String region) {
    _selectedRegion = region;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<CountryEntity> filtered = _countries;

    // Apply search query filter
    if (_selectedQuery.isNotEmpty) {
      filtered = filtered.where((country) =>
          country.commonName.toLowerCase().contains(_selectedQuery.toLowerCase())).toList();
    }

    // Apply region filter
    if (_selectedRegion != 'All') {
      filtered = filtered.where((country) => country.region == _selectedRegion).toList();
    }

    _filteredCountries = filtered;
  }
}
