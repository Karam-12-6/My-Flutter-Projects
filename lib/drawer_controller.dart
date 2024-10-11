import 'package:calculator_app/calculation_model.dart';
import 'package:calculator_app/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List<Calculation> calculations = [];
Set<int> toDelete = {};

class DrawerController extends ChangeNotifier {
  bool _checkBoxVisible = false;
  set checkBoxVisible(bool value) {
    _checkBoxVisible = value;
    notifyListeners();
  }

  bool get checkBoxVisible => _checkBoxVisible;

  // Pair<Calculation, bool>? findCalculation(int id) {
  //   for (var calculation in calculationCheckBox) {
  //     if (calculation.first.id == id) {
  //       return calculation;
  //     }
  //   }
  //   return null;
  // }

  void delete() {
    DatabaseHelper().deleteCalculations(toDelete.toList());
    checkBoxVisible = false;
    notifyListeners();
  }
}

class SingleCalculationController extends ChangeNotifier {
  void setCalculationCheckBox(int index) {
    int id = calculations[index].id!;
    bool alreadyChecked = toDelete.contains(id);
    if (alreadyChecked) {
      toDelete.remove(id);
    } else {
      toDelete.add(id);
    }
    notifyListeners();
  }

  void selectAll() {
    if (toDelete.length != calculations.length) {
      toDelete.addAll(calculations.map((e) => e.id!).toList());
    } else {
      toDelete.clear();
    }
    notifyListeners();
  }
}

class Pair<T1, T2> {
  T1 first;
  T2 second;
  Pair(this.first, this.second);
}
