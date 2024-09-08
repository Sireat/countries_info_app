import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import sqflite_common_ffi

import 'features/country/data/datasources/country_remote_datasource.dart';
import 'features/country/data/repositories/country_repository_impl.dart';
import 'features/country/presentation/pages/country_list_page.dart';
import 'features/country/presentation/providers/country_provider.dart';

void main() {
  // Initialize the FFI and set the database factory for desktop platforms
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi; // Set the database factory to FFI

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
