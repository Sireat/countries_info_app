import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/country_provider.dart';
import 'country_details_page.dart';

class CountryListPage extends StatelessWidget {
  const CountryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CountryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries Info'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Countries',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: provider.filterCountries,
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage.isNotEmpty
                    ? Center(child: Text(provider.errorMessage))
                    : ListView.builder(
                        itemCount: provider.filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = provider.filteredCountries[index];
                          return ListTile(
                            leading: Image.network(country.flag, width: 50),
                            title: Text(country.name),
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
          ),
        ],
      ),
    );
  }
}
