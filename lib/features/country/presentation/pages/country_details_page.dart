import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/country_entity.dart';
import '../providers/country_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CountryDetailsPage extends StatefulWidget {
  final CountryEntity country;

  const CountryDetailsPage({super.key, required this.country});

  @override
  _CountryDetailsPageState createState() => _CountryDetailsPageState();
}

class _CountryDetailsPageState extends State<CountryDetailsPage> {
  late Future<bool> _isFavoriteFuture;

  @override
  void initState() {
    super.initState();
    _isFavoriteFuture = Provider.of<CountryProvider>(context, listen: false)
        .isFavorite(widget.country);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CountryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.commonName),
        actions: [
          FutureBuilder<bool>(
            future: _isFavoriteFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Icon(Icons.favorite_border);
              } else if (snapshot.hasData && snapshot.data!) {
                return IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    provider.toggleFavorite(widget.country);
                    setState(() {
                      _isFavoriteFuture = provider.isFavorite(widget.country);
                    });
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    provider.toggleFavorite(widget.country);
                    setState(() {
                      _isFavoriteFuture = provider.isFavorite(widget.country);
                    });
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.country.flag),
            const SizedBox(height: 16),
            Text('Official Name: ${widget.country.officialName}', style: const TextStyle(fontSize: 16)),
            Text('Capital: ${widget.country.capital}', style: const TextStyle(fontSize: 16)),
            Text('Region: ${widget.country.region}', style: const TextStyle(fontSize: 16)),
            Text('Languages: ${widget.country.languages.join(', ')}', style: const TextStyle(fontSize: 16)),
            Text('Area: ${widget.country.area} km²', style: const TextStyle(fontSize: 16)),
            Text('Population: ${widget.country.population}', style: const TextStyle(fontSize: 16)),
            Text('Demonym: ${widget.country.demonym}', style: const TextStyle(fontSize: 16)),
            Text('Car Side: ${widget.country.carSide}', style: const TextStyle(fontSize: 16)),
            Text('Timezone: ${widget.country.timezone}', style: const TextStyle(fontSize: 16)),
            Text('Borders: ${widget.country.borders.join(', ')}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Maps: ', style: TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: () => _launchURL(widget.country.mapsUrl),
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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
