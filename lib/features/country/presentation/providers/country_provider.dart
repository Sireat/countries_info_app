import 'package:flutter/material.dart';
import '../../data/local/database_helper.dart';
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

  /// Fetches the list of countries from the repository and applies filters.
  Future<void> fetchCountries() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    try {
      _countries = await repository.getAllCountries();
      _filteredCountries = _countries; // Initialize with unfiltered list
      _applyFilters(); // Apply any existing filters
    } catch (e) {
      _errorMessage = 'Failed to load countries: ${e.toString()}'; // More detailed error message
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filters countries based on the search query.
  void filterCountries(String query) {
    _selectedQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Filters countries based on the selected region.
  void filterByRegion(String region) {
    _selectedRegion = region;
    _applyFilters();
    notifyListeners();
  }

  /// Applies search and region filters to the country list.
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

  /// Toggles the favorite status of a country.
  Future<void> toggleFavorite(CountryEntity country) async {
    final isFavorite = await dbHelper.isFavorite(country.commonName);

    if (isFavorite) {
      await dbHelper.removeFavorite(country.commonName);
    } else {
      await dbHelper.addFavorite(country.commonName);
    }
    notifyListeners();
  }

  /// Checks if a country is marked as a favorite.
  Future<bool> isFavorite(CountryEntity country) async {
    return await dbHelper.isFavorite(country.commonName);
  }

  /// Retrieves the list of favorite country names.
  Future<List<String>> getFavorites() async {
    return await dbHelper.getFavorites();
  }
}
