import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'HabitTrackerScreen.dart';

class NameInputController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  void signUp() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter a name',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      // Check if the user already exists
      final response = await _supabase
          .from('users')
          .select('id')
          .eq('name', name)
          .maybeSingle();

      if (response != null) {
        Get.snackbar('Info', 'User already exists. Please sign in.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Create a new user
      final user = await _supabase
          .from('users')
          .insert({'name': name})
          .select()
          .single();

      // Navigate to HabitTrackerScreen
      Get.to(() => HabitTrackerScreen(guestName: name, userId: user['id']));
    } catch (e) {
      Get.snackbar('Error', 'Sign-Up failed: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signIn() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter a name',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      // Check if the user exists
      final response = await _supabase
          .from('users')
          .select('id')
          .eq('name', name)
          .maybeSingle();

      if (response == null) {
        Get.snackbar('Info', 'User not found. Please sign up.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Navigate to HabitTrackerScreen
      Get.to(() => HabitTrackerScreen(guestName: name, userId: response['id']));
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Sign-In failed: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
