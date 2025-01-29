import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../task/HabitDetailScreen.dart';
import 'HabitController.dart';
import '../task/taskController.dart';
import '../../routes/routes.dart';

class HabitTrackerScreen extends StatelessWidget {
  // final String guestName;
  // final String userId;

  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HabitController _habitController = Get.put(HabitController());
    // problem in taskcontroller

    _habitController.fetchHabits(userId: _habitController.userId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Guest: ${_habitController.guestName}',
                  style: TextStyle(fontSize: 18),
                ),
                Obx(() {
                  // print('in obx = ${_habitController.totalScore}');
                  return Text(
                    'Total Score: ${_habitController.totalScore}',
                    style: TextStyle(fontSize: 18),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: _habitController.habits.length,
                itemBuilder: (context, index) {
                  final habit = _habitController.habits[index];

                  return ListTile(
                    title: Text(habit['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              final TextEditingController _editController =
                                  TextEditingController(text: habit['name']);

                              Get.dialog(
                                AlertDialog(
                                  title: Text('Edit Habit'),
                                  content: TextField(
                                    controller: _editController,
                                    decoration: InputDecoration(
                                      labelText: 'Update Habit Name',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_editController.text.isNotEmpty) {
                                          Get.find<HabitController>().editHabit(
                                              habit['id'],
                                              _editController.text,
                                              _habitController.userId);
                                          Get.back();
                                        }
                                      },
                                      child: Text('Save'),
                                    ),
                                  ],
                                ),
                              );
                            }
                            // _showEditHabitDialog(habit['id'], habit['name']),
                            ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _habitController.deleteHabit(
                              habit['id'], _habitController.userId),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Get.to(
                      //   () => HabitDetailScreen(
                      //     habitId: habit['id'],
                      //     habitName: habit['name'],
                      //     userId: userId,
                      //   ),
                      // );

                      Get.toNamed(AppRoutes.task, arguments: {
                        'habitId': habit['id'],
                        'habitName': habit['name'],
                        'userId': _habitController.userId,
                      });
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final TextEditingController _habitControllertext =
              TextEditingController();

          Get.dialog(
            AlertDialog(
              title: Text('Add Habit'),
              content: TextField(
                controller: _habitControllertext,
                decoration: InputDecoration(labelText: 'Enter Habit'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_habitControllertext.text.isNotEmpty) {
                      Get.find<HabitController>().addHabit(
                          _habitControllertext.text, _habitController.userId);
                      Get.back();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
