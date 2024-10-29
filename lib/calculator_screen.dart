import 'package:calculator_app/calculation_controller.dart';
import 'package:calculator_app/widgets/drawer_child.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class CalculatorScreen extends StatelessWidget {
  CalculatorScreen({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(
                Icons.history,
                color: Colors.black,
              ),
            ),
          ),
          drawer: const Drawer(
            child: DrawerChild(),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 9,
                  //color: Colors.white,
                  //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: TextField(
                    controller: context
                        .watch<CalculationController>()
                        .expressionController,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 13),
                    readOnly: true,
                    autofocus: true,
                    showCursor: true,
                    decoration: null,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 9,
                        child: Consumer<CalculationController>(
                          builder: (context, controller, child) {
                            return IconButton(
                              onPressed: () =>
                                  controller.deleteFromExpression(),
                              icon: const Icon(Icons.backspace,
                                  color: Colors.green),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 3),
                //const SizedBox(height: 8),
                buildGridView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Consumer buildGridView() {
    return Consumer<CalculationController>(
      builder: (context, controller, child) {
        List<String> characters = [
          'C',
          '(',
          ')',
          '÷',
          '7',
          '8',
          '9',
          'x',
          '4',
          '5',
          '6',
          '-',
          '1',
          '2',
          '3',
          '+',
          '.',
          '0',
          '=',
        ];
        // var [width, height] = [MediaQuery.of(context).size.width, MediaQuery.of(context).size.height];
        double width = MediaQuery.of(context).size.width;
        return Expanded(
          child: SizedBox(
            width: min(width, 420),
            // width: min((width*height)/20, 500),
            // height: MediaQuery.of(context).size.height/1.5,
            child: GridView.builder(
              primary: true,
              padding: const EdgeInsets.fromLTRB(6, 17, 6, 2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 11,
                mainAxisSpacing: 14,
              ),
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,

              itemCount: characters.length,
              itemBuilder: (context, index) {
                String char = characters[index];
                if (index > 0 && index < characters.length - 1) {
                  return CustomCalculatorButton(
                      character: char,
                      onPressed: () => controller.addToExpression(char));
                } else if (index == 0) {
                  return CustomCalculatorButton(
                      character: char,
                      onPressed: () => controller.emptyExpression());
                }
                return CustomCalculatorButton(
                    character: char,
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () => controller.getExpressionResult(context));
              },
            ),
          ),
        );
      },
    );
  }
}

class CustomCalculatorButton extends StatelessWidget {
  final String character;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;
  final Color textColor;
  const CustomCalculatorButton({
    super.key,
    required this.character,
    required this.onPressed,
    this.textColor = Colors.green,
    this.color = Colors.white,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Feedback.forTap(context);
          onPressed();
        },
        child: Container(
          // height: MediaQuery.of(context).size.height / 8.45,
          // width: MediaQuery.of(context).size.width / 4.35,
          // width: width ?? 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(4, 8),
                spreadRadius: 0.7,
              ),
            ],
          ),
          child: Center(
            child: Text(
              character,
              style: TextStyle(color: textColor, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
