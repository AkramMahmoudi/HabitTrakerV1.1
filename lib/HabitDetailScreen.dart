import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'HabitController.dart';

class HabitDetailScreen extends StatelessWidget {
  final int habitId;
  final String habitName;
  final String userId; // Add userId parameter
  HabitDetailScreen(
      {super.key,
      required this.habitId,
      required this.habitName,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    final HabitController _habitController = Get.find();
    _habitController.fetchTasks(habitId, userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(habitName),
      ),
      body: Obx(() {
        final tasks = _habitController.tasks[habitId] ?? [];
        return tasks.isEmpty
            ? Center(child: Text('No tasks available for $habitName'))
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    leading: Checkbox(
                      value: task['completed'],
                      onChanged: (value) {
                        _habitController.toggleTaskCompletion(
                          task['id'],
                          value ?? false,
                          userId,
                        );
                      },
                    ),
                    title: Text(task['task']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            final TextEditingController _taskController =
                                TextEditingController(text: task['task']);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Edit Task'),
                                  content: TextField(
                                    controller: _taskController,
                                    decoration: InputDecoration(
                                      labelText: 'Task Name',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_taskController.text.isNotEmpty) {
                                          _habitController.editTask(
                                            task['id'],
                                            _taskController.text,
                                            userId,
                                          );
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _habitController.deleteTask(
                                habitId, task['id'], userId);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final TextEditingController _taskController = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Task for $habitName'),
                content: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    labelText: 'Enter Task',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_taskController.text.isNotEmpty) {
                        _habitController.addTask(habitId, _taskController.text,
                            DateTime.now(), userId);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
