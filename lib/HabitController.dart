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
    fetchTotalScore();
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
      fetchTotalScore();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Delete a habit
  void deleteHabit(int id, String userId) async {
    try {
      await _supabaseService.deleteHabit(id, userId);
      fetchHabits(userId: userId);
      fetchTotalScore();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Edit a habit
  void editHabit(int id, String newName, String userId) async {
    try {
      await _supabaseService.editHabit(id, newName, userId);
      fetchHabits(userId: userId);
      fetchTotalScore();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void fetchTotalScore() async {
    try {
      // print('Updated=');
      totalScore.value = await _supabaseService.getTotalHabitScore();
      // print('Updated Total Score: ${totalScore.value}');
    } catch (e) {
      // print('Error in fetchTotalScore: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  void fetchTasks(int habitId) async {
    try {
      tasks[habitId] = await _supabaseService.getTasks(habitId);
      fetchTotalScore();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void addTask(int habitId, String task, DateTime date) async {
    try {
      await _supabaseService.addTask(habitId, task, date);
      fetchTasks(habitId);
      fetchTotalScore();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void deleteTask(int habitId, int taskId) async {
    try {
      await _supabaseService.deleteTask(taskId);
      fetchTasks(habitId);
      fetchTotalScore();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void toggleTaskCompletion(int taskId, bool completed) async {
    try {
      // Toggle task completion in the database
      await _supabaseService.toggleTaskCompletion(taskId, completed);

      // Find the habit ID associated with the task
      final habitId = tasks.keys.firstWhere(
          (id) => tasks[id]?.any((task) => task['id'] == taskId) ?? false);

      // Adjust the habit score based on the task's completion status
      if (completed) {
        await _supabaseService.incrementHabitScore(habitId);
      } else {
        await _supabaseService
            .decrementHabitScore(habitId); // New decrement method
      }

      // Refresh the tasks and total score
      fetchTasks(habitId);
      fetchTotalScore();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void editTask(int taskId, String newTask) async {
    try {
      await _supabaseService.editTask(taskId, newTask);
      fetchTasks(tasks.keys.firstWhere(
          (id) => tasks[id]?.any((task) => task['id'] == taskId) ?? false));
      fetchTotalScore();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
