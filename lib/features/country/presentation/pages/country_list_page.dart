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
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (query) {
                    provider.filterCountries(query);
                  },
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: provider.selectedRegion,
                  onChanged: (value) {
                    if (value != null) {
                      provider.filterByRegion(value);
                    }
                  },
                  items: <String>['All', 'Africa', 'Asia', 'Europe', 'Oceania', 'Americas']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
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
