import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'features/country/data/datasources/country_remote_datasource.dart';
import 'features/country/data/repositories/country_repository_impl.dart';
import 'features/country/presentation/pages/country_list_page.dart';
import 'features/country/presentation/providers/country_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CountryProvider(
            CountryRepositoryImpl(
              CountryRemoteDataSourceImpl(http.Client()),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Countries Info App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CountryListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
