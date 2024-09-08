import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import 'country_details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CountryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: FutureBuilder<List<String>>(
        future: provider.getFavorites(), // Fetch favorites from the database
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          } else {
            final favoriteNames = snapshot.data!;

            // Fetch all countries to ensure filteredCountries has the full list
            final allCountries = provider.filteredCountries;

            // Filter the countries to only include favorites
            final favoriteCountries = allCountries
                .where((country) => favoriteNames.contains(country.commonName))
                .toList();

            return ListView.builder(
              itemCount: favoriteCountries.length,
              itemBuilder: (context, index) {
                final country = favoriteCountries[index];
                return ListTile(
                  leading: Image.network(country.flag, width: 50),
                  title: Text(country.commonName),
                  subtitle: Text(country.region),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CountryDetailsPage(country: country),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
