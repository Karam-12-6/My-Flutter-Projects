import 'package:calculator_app/calculation_model.dart';
import 'package:calculator_app/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DrawerController extends ChangeNotifier {
  bool _checkBoxVisible = false;
  List<Pair<Calculation, bool>> calculationCheckBox = [];
  set checkBoxVisible(bool value) {
    _checkBoxVisible = value;
    notifyListeners();
  }

  bool get checkBoxVisible => _checkBoxVisible;

  Pair<Calculation, bool>? findCalculation(int id) {
    for (var calculation in calculationCheckBox) {
      if (calculation.first.id == id) {
        return calculation;
      }
    }
    return null;
  }

  void setCalculationCheckBox(int index) {
    calculationCheckBox[index].second = !calculationCheckBox[index].second;
    notifyListeners();
  }

  void selectAll() {
    for (var checked in calculationCheckBox) {
      checked.second = true;
    }
    notifyListeners();
  }

  void delete() {
    List<int> checkedCalculations = [];
    for (var calculation in calculationCheckBox) {
      if (calculation.second == true) {
        checkedCalculations.add(calculation.first.id!);
      }
    }
    DatabaseHelper().deleteCalculations(checkedCalculations);
    //checkBoxVisible = false;
    notifyListeners();
  }
}

class Pair<T1, T2> {
  T1 first;
  T2 second;
  Pair(this.first, this.second);
}
