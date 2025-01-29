import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main/HabitController.dart';
import 'taskController.dart';

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final HabitController _habitController = Get.find<HabitController>();
    final taskController _taskController = Get.put(taskController());
    _taskController.fetchTasks(_taskController.habitId, _taskController.userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_taskController.habitName),
      ),
      body: Obx(() {
        final tasks = _taskController.tasks[_taskController.habitId] ?? [];
        // print(tasks);
        return tasks.isEmpty
            ? Center(
                child:
                    Text('No tasks available for ${_taskController.habitName}'))
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    leading: Checkbox(
                      value: task['completed'],
                      onChanged: (value) {
                        // print("++++++++++++++");
                        final habitId = _habitController.habits.firstWhere(
                            (habit) => habit['id'] == task['habit_id'])['id'];
                        // print(habitId);
                        // Optimistic UI update
                        _taskController.updateTaskStateLocally(
                            habitId, task['id'], value ?? false);

                        _taskController.toggleTaskCompletion(task['id'],
                            value ?? false, _taskController.userId, habitId);
                      },
                    ),
                    title: Text(task['task']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            final TextEditingController _tasktextController =
                                TextEditingController(text: task['task']);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Edit Task'),
                                  content: TextField(
                                    controller: _tasktextController,
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
                                        if (_tasktextController
                                            .text.isNotEmpty) {
                                          _taskController.editTask(
                                            task['id'],
                                            _tasktextController.text,
                                            _taskController.userId,
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
                            _taskController.deleteTask(_taskController.habitId,
                                task['id'], _taskController.userId);
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
          final TextEditingController _tasktextController =
              TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Task for ${_taskController.habitName}'),
                content: TextField(
                  controller: _tasktextController,
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
                      if (_tasktextController.text.isNotEmpty) {
                        _taskController.addTask(
                            _taskController.habitId,
                            _tasktextController.text,
                            DateTime.now(),
                            _taskController.userId);
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
