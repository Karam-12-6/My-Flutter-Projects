import 'package:calculator_app/calculation_controller.dart';
import 'package:calculator_app/calculator_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/drawer_controller.dart' as dr;

void main() {
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
      ],
      child: MaterialApp(
        title: 'Calculation App',
        debugShowCheckedModeBanner: false,
        home: CalculatorScreen(),
      ),
    );
  }
}
