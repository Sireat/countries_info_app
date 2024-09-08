import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/country_entity.dart';

class CountryDetailsPage extends StatelessWidget {
  final CountryEntity country;

  const CountryDetailsPage({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.commonName),  // Corrected from commonName to name
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(country.flag),
            const SizedBox(height: 16),
            Text('Official Name: ${country.officialName}', style: const TextStyle(fontSize: 16)),
            Text('Capital: ${country.capital}', style: const TextStyle(fontSize: 16)),
            Text('Region: ${country.region}', style: const TextStyle(fontSize: 16)),
            Text('Languages: ${country.languages.join(', ')}', style: const TextStyle(fontSize: 16)),
            Text('Currency: ${country.currency}', style: const TextStyle(fontSize: 16)), // Added currency
            Text('Area: ${country.area} km²', style: const TextStyle(fontSize: 16)),
            Text('Population: ${country.population}', style: const TextStyle(fontSize: 16)),
            Text('Demonym: ${country.demonym}', style: const TextStyle(fontSize: 16)),
            Text('Car Side: ${country.carSide}', style: const TextStyle(fontSize: 16)),
            Text('Timezone: ${country.timezone}', style: const TextStyle(fontSize: 16)),
            Text('Borders: ${country.borders.join(', ')}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Maps: ', style: TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: () => _launchURL(country.mapsUrl),
              child: const Text(
                'Google Maps Link',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
