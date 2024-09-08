import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/country_provider.dart';
import 'country_details_page.dart';
import 'favorites_page.dart';

class CountryListPage extends StatefulWidget {
  const CountryListPage({super.key});

  @override
  // State management for CountryListPage
  // ignore: library_private_types_in_public_api
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  Timer? _timer;
  bool _isTimeout = false;

  @override
  void initState() {
    super.initState();
    // Start fetching countries with a timeout mechanism
    _startFetchWithTimeout();
  }

  void _startFetchWithTimeout() {
    final provider = Provider.of<CountryProvider>(context, listen: false);
    provider.fetchCountries();

    // Start a timer to check if fetching takes too long
    _timer = Timer(const Duration(seconds: 10), () {
      if (provider.filteredCountries.isEmpty && !provider.isLoading) {
        setState(() {
          _isTimeout = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CountryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Countries',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoritesPage(),
                  ),
                );
              },
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(Icons.search, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                    onChanged: (query) {
                      // Filter countries based on search query
                      provider.filterCountries(query);
                      _resetTimeout();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButton<String>(
                    value: provider.selectedRegion,
                    onChanged: (value) {
                      if (value != null) {
                        // Filter countries based on selected region
                        provider.filterByRegion(value);
                        _resetTimeout();
                      }
                    },
                    items: <String>['All', 'Africa', 'Asia', 'Europe', 'Oceania', 'Americas']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    icon: const Icon(Icons.filter_list, color: Colors.grey),
                    style: const TextStyle(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                    underline: const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.errorMessage.isNotEmpty
                ? _buildErrorDisplay(provider.errorMessage)
                : _isTimeout || provider.filteredCountries.isEmpty
                    ? _buildErrorDisplay('No countries found.')
                    : ListView.builder(
                        itemCount: provider.filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = provider.filteredCountries[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  country.flag,
                                  width: 60,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error, color: Colors.redAccent),
                                ),
                              ),
                              title: Text(
                                country.commonName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                country.region,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CountryDetailsPage(country: country),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  // Reset the timeout when search or filter is performed
  void _resetTimeout() {
    _timer?.cancel();
    setState(() {
      _isTimeout = false;
    });
    _startFetchWithTimeout();
  }

  // Display error messages with retry button
  Widget _buildErrorDisplay(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning,
            size: 60,
            color: Colors.orange.shade700,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _resetTimeout();
              Provider.of<CountryProvider>(context, listen: false).fetchCountries();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
