import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/country_provider.dart';
import 'country_details_page.dart';

class CountryListPage extends StatelessWidget {
  const CountryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CountryProvider>(context);

    if (!provider.isLoading && provider.filteredCountries.isEmpty) {
      provider.fetchCountries();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: provider.filterCountries,
            ),
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage.isNotEmpty
              ? Center(child: Text(provider.errorMessage))
              : ListView.builder(
                  itemCount: provider.filteredCountries.length,
                  itemBuilder: (context, index) {
                    final country = provider.filteredCountries[index];
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
                ),
    );
  }
}
