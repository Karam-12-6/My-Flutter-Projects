import 'dart:io';

import 'package:calculator_app/calculation_controller.dart';
import 'package:calculator_app/calculator_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/drawer_controller.dart' as dr;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CalculationController()),
        ChangeNotifierProvider(create: (context) => dr.DrawerController()),
        ChangeNotifierProvider(create: (context) => dr.SingleCalculationController())
      ],
      child: MaterialApp(
        title: 'Calculator App',
        debugShowCheckedModeBanner: false,
        home: CalculatorScreen(),
      ),
    );
  }
}
