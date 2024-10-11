import 'package:calculator_app/calculation_controller.dart';
import 'package:calculator_app/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/drawer_controller.dart' as drawer_controller;

class DrawerChild extends StatefulWidget {
  const DrawerChild({super.key});

  @override
  State<DrawerChild> createState() => _DrawerChildState();
}

class _DrawerChildState extends State<DrawerChild> {
  @override
  Widget build(BuildContext context) {
    drawer_controller.DrawerController controller =
        context.watch<drawer_controller.DrawerController>();
    drawer_controller.SingleCalculationController singleCalculationController =
        context.read<drawer_controller.SingleCalculationController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            if (controller.checkBoxVisible) {
              controller.checkBoxVisible = false;
              drawer_controller.toDelete.clear();
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 70,
                color: Colors.white,
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
                            onPressed: () =>
                                singleCalculationController.selectAll(),
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
              // const SizedBox(height: 10),
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
        
                      drawer_controller.calculations = snapshot.data!;
        
                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 20),
                        separatorBuilder: (context, i) => const SizedBox(height: 8),
                        itemCount: drawer_controller.calculations.length,
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Consumer<drawer_controller.SingleCalculationController>(
                            builder: (context, singleCalculationController, child) {
                              return Row(
                                
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 6, 0, 2),
                                    child: Ink(
                                      width: controller.checkBoxVisible
                                          ? constraints.maxWidth / 1.3
                                          : constraints.maxWidth / 1.1,
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
                                          singleCalculationController
                                              .setCalculationCheckBox(index);
                                          controller.checkBoxVisible = true;
                                        },
                                        onTap: () {
                                          Feedback.forTap(context);
                                          context
                                                  .read<CalculationController>()
                                                  .expressionController
                                                  .text =
                                              drawer_controller
                                                  .calculations[index].expression!;
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
                                                    '${drawer_controller.calculations[index].expression.toString()}  =  ${drawer_controller.calculations[index].result.toString()}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 24),
                                                    softWrap: true,
                                                    textWidthBasis:
                                                        TextWidthBasis.longestLine,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    drawer_controller
                                                        .calculations[index].timestamp
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
                                  const SizedBox(width: 4),
                                  Visibility(
                                    visible: controller.checkBoxVisible,
                                    child: Checkbox(
                                      value: drawer_controller.toDelete.contains(
                                          drawer_controller.calculations[index].id),
                                      onChanged: (value) {
                                        singleCalculationController
                                            .setCalculationCheckBox(index);
                                        value = !(value ?? true);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
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
    );
  }
}
