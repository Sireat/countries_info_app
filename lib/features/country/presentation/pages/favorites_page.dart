import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import 'country_details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain the CountryProvider from the context
    final provider = Provider.of<CountryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true, // Center the title in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<String>>(
          future: provider.getFavorites(), // Fetch the list of favorite countries from the provider
          builder: (context, snapshot) {
            // Display a loading spinner while the data is being fetched
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            // Display an error message if there was an error fetching the data
            else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } 
            // Display a message if there are no favorites
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No favorites yet.', style: TextStyle(fontSize: 18)));
            } 
            // Display the list of favorite countries
            else {
              final favoriteNames = snapshot.data!;

              // Fetch the full list of countries to filter by favorites
              final allCountries = provider.filteredCountries;

              // Filter the list to include only those countries that are favorites
              final favoriteCountries = allCountries
                  .where((country) => favoriteNames.contains(country.commonName))
                  .toList();

              return ListView.builder(
                itemCount: favoriteCountries.length, // Number of favorite countries
                itemBuilder: (context, index) {
                  final country = favoriteCountries[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0, // Elevation for shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners for the card
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          country.flag,
                          width: 80, // Width of the country flag image
                          height: 60, // Height of the country flag image
                          fit: BoxFit.cover, // Ensure the image covers the allocated space
                        ),
                      ),
                      title: Text(
                        country.commonName,
                        style: const TextStyle(fontWeight: FontWeight.bold), // Bold text for the country name
                      ),
                      subtitle: Text(
                        country.region,
                        style: const TextStyle(color: Colors.grey), // Grey text for the region
                      ),
                      onTap: () {
                        // Navigate to the details page for the selected country
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
              );
            }
          },
        ),
      ),
    );
  }
}
