import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // Fetch all habits
  Future<List<Map<String, dynamic>>> getHabits() async {
    try {
      final response = await _supabase.from('habits').select('*');

      // Check if response is not empty
      if (response.isNotEmpty) {
        return response;
      } else {
        // Handle case where no data is returned
        return [];
      }
    } catch (e) {
      // Handle any errors that occur during the request
      throw Exception('Failed to fetch habits: $e');
    }
  }

  // Add a habit
  Future<void> addHabit(String name) async {
    try {
      await _supabase.from('habits').insert({'name': name});
    } catch (e) {
      throw Exception('Failed to add habit: $e');
    }
  }

  // Edit a habit
  Future<void> editHabit(int id, String newName) async {
    try {
      await _supabase.from('habits').update({'name': newName}).eq('id', id);
    } catch (e) {
      throw Exception('Failed to edit habit: $e');
    }
  }

  // Delete a habit
  Future<void> deleteHabit(int id) async {
    try {
      await _supabase.from('habits').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete habit: $e');
    }
  }

  // Fetch tasks for a habit
  Future<List<Map<String, dynamic>>> getTasks(int habitId) async {
    try {
      final response =
          await _supabase.from('tasks').select('*').eq('habit_id', habitId);

      if (response.isNotEmpty) {
        return response;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  // Add a task
  Future<void> addTask(int habitId, String task, DateTime date) async {
    try {
      await _supabase.from('tasks').insert({
        'habit_id': habitId,
        'task': task,
        'date': date.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  // Edit a task
  Future<void> editTask(int id, String newTask) async {
    try {
      await _supabase.from('tasks').update({'task': newTask}).eq('id', id);
    } catch (e) {
      throw Exception('Failed to edit task: $e');
    }
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    try {
      await _supabase.from('tasks').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // Toggle task completion
  Future<void> toggleTaskCompletion(int id, bool completed) async {
    try {
      await _supabase
          .from('tasks')
          .update({'completed': completed}).eq('id', id);
    } catch (e) {
      throw Exception('Failed to toggle task completion: $e');
    }
  }

  Future<void> incrementHabitScore(int habitId) async {
    try {
      // Fetch the current score for the habit
      final response = await _supabase
          .from('habits')
          .select('score')
          .eq('id', habitId)
          .single();

      final currentScore = response['score'] as int;

      // Increment the score
      final newScore = currentScore + 1;

      // Update the score in the database
      await _supabase
          .from('habits')
          .update({'score': newScore}).eq('id', habitId);
    } catch (e) {
      throw Exception('Failed to increment habit score: $e');
    }
  }

  Future<void> decrementHabitScore(int habitId) async {
    try {
      // Fetch the current score for the habit
      final response = await _supabase
          .from('habits')
          .select('score')
          .eq('id', habitId)
          .single();

      final currentScore = response['score'] as int;

      // Decrement the score if it's greater than 0
      final newScore = (currentScore > 0) ? currentScore - 1 : 0;

      // Update the score in the database
      await _supabase
          .from('habits')
          .update({'score': newScore}).eq('id', habitId);
    } catch (e) {
      throw Exception('Failed to decrement habit score: $e');
    }
  }

  Future<int> getTotalHabitScore() async {
    try {
      // Fetch RPC response
      final response = await _supabase.rpc('get_total_habit_score');

      // Log response for debugging
      // print('Response from Supabase RPC: $response');

      // Ensure response is not null or empty
      if (response == null || response.isEmpty) {
        // print('Supabase RPC returned empty or null data.');
        return 0; // Default to 0
      }

      // Extract the total_score from the first item in the list
      final totalScore = response[0]['total_score'];
      if (totalScore == null) {
        // print('Error: total_score is null in the response data.');
        return 0; // Default to 0 if total_score is missing
      }

      // print('Extracted total_score: $totalScore');
      return totalScore;
    } catch (e) {
      // Handle exceptions and log errors
      // print('Error in getTotalHabitScore: $e');
      throw Exception('Failed to fetch total habit score: $e');
    }
  }
}
