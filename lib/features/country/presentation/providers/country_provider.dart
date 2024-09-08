import 'package:flutter/material.dart';
import '../../../../core/local/database_helper.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/country_repository.dart';

class CountryProvider with ChangeNotifier {
  final CountryRepository repository;
  final DatabaseHelper dbHelper = DatabaseHelper(); // Singleton DatabaseHelper

  List<CountryEntity> _countries = [];
  List<CountryEntity> _filteredCountries = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedRegion = 'All';
  String _selectedQuery = '';

  CountryProvider(this.repository);

  List<CountryEntity> get filteredCountries => _filteredCountries;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedRegion => _selectedRegion;

  Future<void> fetchCountries() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _countries = await repository.getAllCountries();
      _filteredCountries = _countries; // Initialize with unfiltered list
      _applyFilters(); // Apply any existing filters
    } catch (e) {
      _errorMessage = 'Network error: Failed to load countries.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterCountries(String query) {
    _selectedQuery = query;
    _applyFilters();
    if (_filteredCountries.isEmpty) {
      _errorMessage = 'Country not found for "$query".'; // Set error message when no results found
    } else {
      _errorMessage = ''; // Clear error message when results are found
    }
    notifyListeners();
  }

  void filterByRegion(String region) {
    _selectedRegion = region;
    _applyFilters();
    if (_filteredCountries.isEmpty) {
      _errorMessage = 'No countries found in the "$region" region.'; // Set error message when no results found
    } else {
      _errorMessage = '';
    }
    notifyListeners();
  }

  void _applyFilters() {
    List<CountryEntity> filtered = _countries;

    if (_selectedQuery.isNotEmpty) {
      filtered = filtered
          .where((country) => country.commonName
              .toLowerCase()
              .contains(_selectedQuery.toLowerCase()))
          .toList();
    }

    if (_selectedRegion != 'All') {
      filtered = filtered.where((country) => country.region == _selectedRegion).toList();
    }

    _filteredCountries = filtered;
  }

  Future<void> toggleFavorite(CountryEntity country) async {
    final isFavorite = await dbHelper.isFavorite(country.commonName);

    if (isFavorite) {
      await dbHelper.removeFavorite(country.commonName);
    } else {
      await dbHelper.addFavorite(country.commonName);
    }

    // Notify listeners to trigger a rebuild
    notifyListeners();
  }

  Future<bool> isFavorite(CountryEntity country) async {
    return await dbHelper.isFavorite(country.commonName);
  }

  Future<List<String>> getFavorites() async {
    return await dbHelper.getFavorites();
  }
}
