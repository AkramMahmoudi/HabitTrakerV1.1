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

  Future<List<Map<String, dynamic>>> fetchHabits(String userId) async {
    try {
      final response =
          await _supabase.from('habits').select('*').eq('user_id', userId);
      return response.isNotEmpty
          ? List<Map<String, dynamic>>.from(response)
          : [];
    } catch (e) {
      throw Exception('Failed to fetch habits: $e');
    }
  }

  // Add a habit
  Future<void> addHabit(String name, String userId) async {
    try {
      await _supabase.from('habits').insert({'name': name, 'user_id': userId});
    } catch (e) {
      throw Exception('Failed to add habit: $e');
    }
  }

  // Edit a habit
  Future<void> editHabit(int id, String newName, String userId) async {
    try {
      await _supabase
          .from('habits')
          .update({'name': newName})
          .eq('id', id)
          .eq('user_id', userId); // Ensure only the user's habit is updated
    } catch (e) {
      throw Exception('Failed to edit habit: $e');
    }
  }

  // Delete a habit
  Future<void> deleteHabit(int id, String userId) async {
    try {
      await _supabase
          .from('habits')
          .delete()
          .eq('id', id)
          .eq('user_id', userId); // Ensure only the user's habit is deleted
    } catch (e) {
      throw Exception('Failed to delete habit: $e');
    }
  }

  // Fetch tasks for a habit
  Future<List<Map<String, dynamic>>> getTasks(int habitId) async {
    try {
      final response = await _supabase
          .from('tasks')
          .select('*')
          .eq('habit_id', habitId)
          .order('created_at', ascending: true);
      // print(response);
      return response.isNotEmpty
          ? List<Map<String, dynamic>>.from(response)
          : [];
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

  Future<void> deleteTask(int id) async {
    try {
      await _supabase.from('tasks').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<void> toggleTaskCompletion(int id, bool completed) async {
    try {
      await _supabase
          .from('tasks')
          .update({'completed': completed}).eq('id', id);
    } catch (e) {
      throw Exception('Failed to toggle task completion: $e');
    }
  }

  // Increment habit score
  Future<void> incrementHabitScore(int habitId, String userId) async {
    try {
      final response = await _supabase
          .from('habits')
          .select('score')
          .eq('id', habitId)
          .eq('user_id', userId)
          .single();

      final currentScore = response['score'] as int;
      final newScore = currentScore + 1;

      await _supabase
          .from('habits')
          .update({'score': newScore})
          .eq('id', habitId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to increment habit score: $e');
    }
  }

  Future<void> decrementHabitScore(int habitId, String userId) async {
    try {
      // Fetch the current score for the habit
      final response = await _supabase
          .from('habits')
          .select('score')
          .eq('id', habitId)
          .eq('user_id', userId) // Ensure the habit belongs to the user
          .single();

      // if (response == null) {
      //   throw Exception('Habit not found for the provided user.');
      // }

      final currentScore = response['score'] as int;

      // Decrement the score if it's greater than 0
      final newScore = (currentScore > 0) ? currentScore - 1 : 0;

      // Update the score in the database
      await _supabase
          .from('habits')
          .update({'score': newScore})
          .eq('id', habitId)
          .eq('user_id', userId); // Ensure only the user's habit is updated
    } catch (e) {
      throw Exception('Failed to decrement habit score: $e');
    }
  }

  Future<int> getTotalHabitScore(String userId) async {
    try {
      final response = await _supabase
          .rpc('get_total_habit_score', params: {'p_user_id': userId});
      return response[0]['total_score'];
    } catch (e) {
      throw Exception('Failed to fetch total habit score: $e');
    }
  }
}
