import 'package:flutter/material.dart';
import '../../../../core/local/database_helper.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/country_repository.dart';

/// A provider class that manages the state related to countries and their favorite status.
class CountryProvider with ChangeNotifier {
  final CountryRepository repository; // Repository to fetch country data
  final DatabaseHelper dbHelper = DatabaseHelper(); // Singleton instance for database operations

  List<CountryEntity> _countries = []; // List of all fetched countries
  List<CountryEntity> _filteredCountries = []; // List of countries filtered based on user input
  bool _isLoading = false; // Loading state indicator
  String _errorMessage = ''; // Error message for displaying to the user
  String _selectedRegion = 'All'; // Selected region filter
  String _selectedQuery = ''; // User's search query

  CountryProvider(this.repository);

  // Public getter for filtered countries
  List<CountryEntity> get filteredCountries => _filteredCountries;

  // Public getter for loading state
  bool get isLoading => _isLoading;

  // Public getter for error message
  String get errorMessage => _errorMessage;

  // Public getter for selected region
  String get selectedRegion => _selectedRegion;

  /// Fetches the list of countries from the repository and initializes the filtered list.
  Future<void> fetchCountries() async {
    _isLoading = true; // Set loading state
    _errorMessage = ''; // Clear any previous error message
    notifyListeners(); // Notify listeners of the loading state change

    try {
      // Fetch countries from the repository
      _countries = await repository.getAllCountries();
      _filteredCountries = _countries; // Initialize filtered countries with the unfiltered list
      _applyFilters(); // Apply any existing filters
    } catch (e) {
      _errorMessage = 'Network error: Failed to load countries.'; // Set error message on failure
    } finally {
      _isLoading = false; // Reset loading state
      notifyListeners(); // Notify listeners of the state change
    }
  }

  /// Filters countries based on the provided search query.
  void filterCountries(String query) {
    _selectedQuery = query; // Update the search query
    _applyFilters(); // Apply filters based on the updated query

    // Set appropriate error message if no results are found
    if (_filteredCountries.isEmpty) {
      _errorMessage = 'Country not found for "$query".';
    } else {
      _errorMessage = ''; // Clear error message if results are found
    }

    notifyListeners(); // Notify listeners of the filter change
  }

  /// Filters countries based on the selected region.
  void filterByRegion(String region) {
    _selectedRegion = region; // Update the selected region
    _applyFilters(); // Apply filters based on the updated region

    // Set appropriate error message if no results are found
    if (_filteredCountries.isEmpty) {
      _errorMessage = 'No countries found in the "$region" region.';
    } else {
      _errorMessage = ''; // Clear error message if results are found
    }

    notifyListeners(); // Notify listeners of the filter change
  }

  /// Applies filters based on the search query and selected region.
  void _applyFilters() {
    List<CountryEntity> filtered = _countries; // Start with the unfiltered list

    // Apply search query filter
    if (_selectedQuery.isNotEmpty) {
      filtered = filtered
          .where((country) => country.commonName
              .toLowerCase()
              .contains(_selectedQuery.toLowerCase()))
          .toList();
    }

    // Apply region filter
    if (_selectedRegion != 'All') {
      filtered = filtered.where((country) => country.region == _selectedRegion).toList();
    }

    _filteredCountries = filtered; // Update the filtered countries list
  }

  /// Toggles the favorite status of a country.
  Future<void> toggleFavorite(CountryEntity country) async {
    final isFavorite = await dbHelper.isFavorite(country.commonName); // Check if the country is a favorite

    // Add or remove from favorites based on current status
    if (isFavorite) {
      await dbHelper.removeFavorite(country.commonName);
    } else {
      await dbHelper.addFavorite(country.commonName);
    }

    // Notify listeners to trigger a rebuild of UI
    notifyListeners();
  }

  /// Checks if a country is marked as a favorite.
  Future<bool> isFavorite(CountryEntity country) async {
    return await dbHelper.isFavorite(country.commonName);
  }

  /// Retrieves the list of favorite countries from the database.
  Future<List<String>> getFavorites() async {
    return await dbHelper.getFavorites();
  }
}
