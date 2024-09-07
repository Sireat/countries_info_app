import 'package:flutter/material.dart';

import '../../domain/entities/country_entity.dart';

class CountryDetailsPage extends StatelessWidget {
  final CountryEntity country;

  const CountryDetailsPage({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(country.flag),
            const SizedBox(height: 16),
            Text('Region: ${country.region}', style: const TextStyle(fontSize: 16)),
            Text('Capital: ${country.capital}', style: const TextStyle(fontSize: 16)),
            Text('Population: ${country.population}', style: const TextStyle(fontSize: 16)),
            Text('Currency: ${country.currency}', style: const TextStyle(fontSize: 16)),
            Text('Languages: ${country.languages.join(', ')}', style: const TextStyle(fontSize: 16)),
            Text('Borders: ${country.borders.join(', ')}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
