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
}
