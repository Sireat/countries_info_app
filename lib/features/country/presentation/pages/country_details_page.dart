import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/country_entity.dart';
import '../providers/country_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CountryDetailsPage extends StatefulWidget {
  final CountryEntity country;

  const CountryDetailsPage({super.key, required this.country});

  @override
  // ignore: library_private_types_in_public_api
  _CountryDetailsPageState createState() => _CountryDetailsPageState();
}

class _CountryDetailsPageState extends State<CountryDetailsPage> with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _loadFavoriteStatus() async {
    final provider = Provider.of<CountryProvider>(context, listen: false);
    _isFavorite = await provider.isFavorite(widget.country);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CountryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.commonName),
        actions: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.grey,
                  size: 28.0 * _animation.value,
                ),
                onPressed: () async {
                  if (_isFavorite) {
                    _animationController.reverse();
                  } else {
                    _animationController.forward();
                    _showSurpriseOverlay(context);
                  }
                  await provider.toggleFavorite(widget.country);
                  _loadFavoriteStatus(); // Refresh the favorite status after toggling
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Improved Flag Display
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                  border: Border.all(
                    color: Colors.black.withOpacity(0.5), // Border color
                    width: 2.0, // Border width
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Shadow color
                      blurRadius: 8.0, // Shadow blur radius
                      offset: const Offset(0, 4), // Shadow offset
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0), // Match container radius
                  child: Image.network(
                    widget.country.flag,
                    width: MediaQuery.of(context).size.width * 0.9, // Responsive width
                    height: MediaQuery.of(context).size.width * 0.5, // Responsive height
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Section Title
            Text(
              'Country Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Information Cards
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4.0, // Higher elevation for better depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Official Name:', widget.country.officialName),
                    _buildInfoRow('Capital:', widget.country.capital),
                    _buildInfoRow('Region:', widget.country.region),
                    _buildInfoRow('Languages:', widget.country.languages.join(', ')),
                    _buildInfoRow('Area:', '${widget.country.area} km²'),
                    _buildInfoRow('Population:', widget.country.population.toString()),
                    _buildInfoRow('Demonym:', widget.country.demonym),
                    _buildInfoRow('Car Side:', widget.country.carSide),
                    _buildInfoRow('Timezone:', widget.country.timezone),
                    _buildInfoRow('Borders:', widget.country.borders.join(', ')),
                    _buildInfoRow('Currency:', widget.country.currency),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Maps Link
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

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
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

  void _showSurpriseOverlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 100.0,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Congratulation!',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'You have a new favorite!',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
