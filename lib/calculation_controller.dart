import 'package:calculator_app/calculation_model.dart';
import 'package:calculator_app/database_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:function_tree/function_tree.dart';
import 'package:toast/toast.dart' as flutter_toast;

class CalculationController extends ChangeNotifier {
  final Calculation _calculation = Calculation();
  TextEditingController expressionController = TextEditingController();

  //this function is used to add new character to the expression and control the position of the cursor
  void addToExpression(String character) {
    int afterSelection = expressionController.selection.start;
    expressionController.text = expressionController.text
            .substring(0, expressionController.selection.start) +
        character +
        expressionController.text
            .substring(expressionController.selection.start);
    expressionController.selection = TextSelection.collapsed(
        offset:
            expressionController.text.substring(0, afterSelection + 1).length);
  }

  //this function is used to delete a character from the exprssion and control the position of the cursor
  void deleteFromExpression() {
    TextSelection currentSelection = expressionController.selection;
    if (expressionController.text.isNotEmpty && currentSelection.start > 0) {
      expressionController.text =
          expressionController.text.substring(0, currentSelection.start - 1) +
              expressionController.text.substring(currentSelection.start);
      expressionController.selection = TextSelection.collapsed(
          offset: expressionController.text
              .substring(0, currentSelection.start - 1)
              .length);
    }
  }

  //this function is used to get the expression result and add the calculation to the history
  void getExpressionResult(context) {
    if (expressionController.text.isNotEmpty) {
      try {
        _calculation.expression = expressionController.text;
        String? expression = _calculation.expression?.replaceAll('x', '*');
        expression = expression?.replaceAll('÷', '/');
        _calculation.result = expression?.interpret() as double;
        expressionController.text = _calculation.result.toString();
        expressionController.selection =
            TextSelection.collapsed(offset: expressionController.text.length);
        addCalculationToHistory();
      } catch (e) {
        flutter_toast.ToastContext().init(context);
        flutter_toast.Toast.show('Invalid calculation');
      }
    }
  }

  void emptyExpression() {
    expressionController.text = '';
    expressionController.selection = const TextSelection.collapsed(offset: 0);
  }

  //this function is used to add a calculation to the history (Sqlite database)
  void addCalculationToHistory() async {
    await DatabaseHelper().database;
    DatabaseHelper().insertCalculation(_calculation);
    notifyListeners();
  }
}
