import 'package:calculator_app/calculation_controller.dart';
import 'package:calculator_app/widgets/drawer_child.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height/13),
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
        ];
        List<Widget> buttons = [
          CustomCalculatorButton(
              character: 'C', onPressed: () => controller.emptyExpression()),
        ];
        buttons.addAll([
          for (String char in characters)
            CustomCalculatorButton(
                character: char,
                onPressed: () => controller.addToExpression(char))
        ]);
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/1.5,
          margin: const EdgeInsets.only(top: 7),
          child: Column(
            children: [
              Expanded(
                child: GridView(
                  padding: const EdgeInsets.fromLTRB(6, 17, 6, 0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 11,
                    mainAxisSpacing: 14,
                  ),
                  children: buttons,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height/6.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CustomCalculatorButton(
                          character: '.',
                          onPressed: () => controller.addToExpression('.')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CustomCalculatorButton(
                          character: '0',
                          onPressed: () => controller.addToExpression('0')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: GestureDetector(
                        onTap: () {
                          Feedback.forTap(context);
                          controller.getExpressionResult(context);
                        },
                        
                        child: Container(
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width / 2.3,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                                offset: const Offset(4, 8),
                                spreadRadius: 0.7,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '=',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
  const CustomCalculatorButton({
    super.key,
    required this.character,
    required this.onPressed,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        onPressed();
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 8.45,
        width: MediaQuery.of(context).size.width / 4.35,
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
            style: const TextStyle(color: Colors.green, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
