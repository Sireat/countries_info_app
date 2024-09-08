import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; 
import 'app.dart'; 

void main() {
  // Initialize the FFI and set the database factory to favorite
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi; // Set the database factory to FFI

  runApp(const MyApp());
}
