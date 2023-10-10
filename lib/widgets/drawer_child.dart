import 'package:calculator_app/calculation_controller.dart';
import 'package:calculator_app/calculation_model.dart';
import 'package:calculator_app/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/drawer_controller.dart' as dr;

class DrawerChild extends StatefulWidget {
  const DrawerChild({super.key});

  @override
  State<DrawerChild> createState() => _DrawerChildState();
}

class _DrawerChildState extends State<DrawerChild> {
  @override
  Widget build(BuildContext context) {
    dr.DrawerController controller = context.watch<dr.DrawerController>();
    return GestureDetector(
      onTap: () {
        if (controller.checkBoxVisible) {
          controller.checkBoxVisible = false;
          for (var calculation in controller.calculationCheckBox) {
            calculation.second = false;
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            //padding: const EdgeInsets.all(5),
            height: 70,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 8, 10),
                  child: Text(
                    'History',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),
                Visibility(
                  visible: controller.checkBoxVisible,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => controller.selectAll(),
                        child: const Text(
                          'Select All',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => controller.delete(),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: DatabaseHelper().getCalculationsList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      'No Calculations in History',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ));
                  }

                  controller.calculationCheckBox = snapshot.data!.map((e) {
                    dr.Pair<Calculation, bool>? calculation =
                        controller.findCalculation(e.id!);
                    return calculation != null
                        ? dr.Pair(e, calculation.second)
                        : dr.Pair(e, false);
                  }).toList();

                  return ListView.separated(
                    separatorBuilder: (context, i) => const SizedBox(height: 8),
                    itemCount: controller.calculationCheckBox.length,
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 6, 0, 2),
                            child: Ink(
                              width: controller.checkBoxVisible
                                  ? MediaQuery.of(context).size.width / 1.68
                                  : MediaQuery.of(context).size.width / 1.48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 2,
                                    offset: const Offset(4, 8),
                                    spreadRadius: 0.7,
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onLongPress: () {
                                  Feedback.forLongPress(context);
                                  controller.checkBoxVisible = true;
                                  controller.calculationCheckBox[index].second =
                                      true;
                                },
                                onTap: () {
                                  Feedback.forTap(context);
                                  context
                                          .read<CalculationController>()
                                          .expressionController
                                          .text =
                                      controller.calculationCheckBox[index]
                                          .first.expression!;
                                  Navigator.of(context).pop();
                                },
                                child: Wrap(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${controller.calculationCheckBox[index].first.expression.toString()}  =  ${controller.calculationCheckBox[index].first.result.toString()}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 24),
                                            softWrap: true,
                                            textWidthBasis:
                                                TextWidthBasis.longestLine,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            controller
                                                .calculationCheckBox[index]
                                                .first
                                                .timestamp
                                                .toString()
                                                .replaceAll(
                                                    RegExp(r'\.\d+'), ''),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.checkBoxVisible,
                            child: Checkbox(
                              value:
                                  controller.calculationCheckBox[index].second,
                              onChanged: (value) {
                                controller.setCalculationCheckBox(index);
                                value = controller
                                    .calculationCheckBox[index].second;
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
