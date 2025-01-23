import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'HabitDetailScreen.dart';
import 'HabitController.dart';
import 'taskController.dart';

class HabitTrackerScreen extends StatelessWidget {
  final String guestName;
  final String userId;

  const HabitTrackerScreen(
      {super.key, required this.guestName, required this.userId});

  @override
  Widget build(BuildContext context) {
    final HabitController _habitController = Get.put(HabitController());
    final taskControllerInstance = Get.put(taskController());
    _habitController.fetchHabits(userId: userId);

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
                  'Guest: $guestName',
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
                          onPressed: () =>
                              _showEditHabitDialog(habit['id'], habit['name']),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              _habitController.deleteHabit(habit['id'], userId),
                        ),
                      ],
                    ),
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => HabitDetailScreen(
                    //         habitId: habit['id'],
                    //         habitName: habit['name'],
                    //         userId: userId,
                    //       ),
                    //     ),
                    //   );
                    // },
                    onTap: () {
                      Get.to(
                        () => HabitDetailScreen(
                          habitId: habit['id'],
                          habitName: habit['name'],
                          userId: userId,
                        ),
                      );
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
          final TextEditingController _habitController =
              TextEditingController();
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       title: Text('Add Habit'),
          //       content: TextField(
          //         controller: _habitController,
          //         decoration: InputDecoration(
          //           labelText: 'Enter Habit',
          //         ),
          //       ),
          //       actions: [
          //         TextButton(
          //           onPressed: () => Navigator.pop(context),
          //           child: Text('Cancel'),
          //         ),
          //         TextButton(
          //           onPressed: () {
          //             if (_habitController.text.isNotEmpty) {
          //               Get.find<HabitController>()
          //                   .addHabit(_habitController.text, userId);
          //               Navigator.pop(context);
          //             }
          //           },
          //           child: Text('Add'),
          //         ),
          //       ],
          //     );
          //   },
          // );
          Get.dialog(
            AlertDialog(
              title: Text('Add Habit'),
              content: TextField(
                controller: _habitController,
                decoration: InputDecoration(labelText: 'Enter Habit'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_habitController.text.isNotEmpty) {
                      Get.find<HabitController>()
                          .addHabit(_habitController.text, userId);
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

  /// Show dialog for editing a habit
  // void _showEditHabitDialog(
  //     BuildContext context, int habitId, String habitName) {
  //   final TextEditingController _editController =
  //       TextEditingController(text: habitName);

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Edit Habit'),
  //         content: TextField(
  //           controller: _editController,
  //           decoration: InputDecoration(
  //             labelText: 'Update Habit Name',
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               if (_editController.text.isNotEmpty) {
  //                 Get.find<HabitController>()
  //                     .editHabit(habitId, _editController.text, userId);
  //                 Navigator.pop(context);
  //               }
  //             },
  //             child: Text('Save'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _showEditHabitDialog(int habitId, String habitName) {
    final TextEditingController _editController =
        TextEditingController(text: habitName);

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
                Get.find<HabitController>()
                    .editHabit(habitId, _editController.text, userId);
                Get.back();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
