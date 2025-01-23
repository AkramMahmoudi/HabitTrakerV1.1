import 'package:get/get.dart';
import 'supabase_service.dart';

class HabitController extends GetxController {
  final SupabaseService _supabaseService = SupabaseService();
  var totalScore = 0.obs;
  var habits = <Map<String, dynamic>>[].obs;
  var tasks = <int, List<Map<String, dynamic>>>{}.obs; // Habit ID -> Tasks

  @override
  void onInit() {
    super.onInit();
    // fetchTotalScore();
  }

  // void fetchAllHabits() async {
  //   try {
  //     habits.value = await _supabaseService.getHabits();
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   }
  // }

  // void fetchHabits({required String userId}) async {
  //   try {
  //     final fetchedHabits = await _supabaseService.fetchHabits(userId);
  //     habits.assignAll(fetchedHabits); // Use assignAll to update the observable
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to fetch habits: $e');
  //   }
  // }

  // Fetch habits
  void fetchHabits({required String userId}) async {
    try {
      fetchTotalScore(userId);
      habits.value = await _supabaseService.fetchHabits(userId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch habits: $e');
    }
  }

  // Add a habit
  void addHabit(String name, String userId) async {
    try {
      await _supabaseService.addHabit(name, userId);
      fetchHabits(userId: userId);
      // fetchTotalScore(userId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Delete a habit
  void deleteHabit(int id, String userId) async {
    try {
      await _supabaseService.deleteHabit(id, userId);
      fetchHabits(userId: userId);
      // fetchTotalScore(userId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Edit a habit
  void editHabit(int id, String newName, String userId) async {
    try {
      await _supabaseService.editHabit(id, newName, userId);
      fetchHabits(userId: userId);
      // fetchTotalScore(userId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void fetchTotalScore(String userId) async {
    try {
      // print('--------------fetchTotalScore---------------');
      totalScore.value = await _supabaseService.getTotalHabitScore(userId);
    } catch (e) {
      // print('----error-----fetchTotalScore---------------');
      // print('--------------${e}---------------');
      Get.snackbar('Error', e.toString());
    }
  }

  void fetchTasks(int habitId, String userId) async {
    try {
      tasks[habitId] = await _supabaseService.getTasks(habitId);

      fetchTotalScore(userId); // Pass userId
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void addTask(int habitId, String task, DateTime date, String userId) async {
    try {
      await _supabaseService.addTask(habitId, task, date);
      fetchTasks(habitId, userId); // Pass userId
      fetchTotalScore(userId); // Pass userId
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void deleteTask(int habitId, int taskId, String userId) async {
    try {
      await _supabaseService.deleteTask(taskId);
      fetchTasks(habitId, userId); // Pass userId
      // fetchTotalScore(userId); // Pass userId
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void updateTaskStateLocally(int habitId, int taskId, bool isCompleted) {
    tasks[habitId] = (tasks[habitId] ?? []).map((task) {
      if (task['id'] == taskId) {
        return {
          ...task,
          'completed': isCompleted,
        }; // Update only the specific task
      }
      return task;
    }).toList();
  }

  void toggleTaskCompletion(int taskId, bool completed, String userId) async {
    try {
      await _supabaseService.toggleTaskCompletion(taskId, completed);

      // Find the habit ID associated with the task
      final habitId = tasks.keys.firstWhere(
          (id) => tasks[id]?.any((task) => task['id'] == taskId) ?? false);

      if (completed) {
        await _supabaseService.incrementHabitScore(habitId, userId);
      } else {
        await _supabaseService.decrementHabitScore(habitId, userId);
      }

      fetchTasks(habitId, userId); // Pass userId
      // fetchTotalScore(userId); // Pass userId
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void editTask(int taskId, String newTask, String userId) async {
    try {
      await _supabaseService.editTask(taskId, newTask);

      // Find the habit ID associated with the task
      final habitId = tasks.keys.firstWhere(
          (id) => tasks[id]?.any((task) => task['id'] == taskId) ?? false);

      fetchTasks(habitId, userId); // Pass userId
      // fetchTotalScore(userId); // Pass userId
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
