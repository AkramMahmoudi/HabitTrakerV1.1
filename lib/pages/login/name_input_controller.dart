import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class NameInputController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  void signUp() async {
    final email = nameController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter a name and password',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        Get.snackbar('Error', 'Sign-Up failed. No user was created.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      Get.toNamed(AppRoutes.home, arguments: {
        'guestName': email,
        'userId': user.id,
      });
      // if (response != null) {
      //   Get.snackbar('Info', 'User already exists. Please sign in.',
      //       snackPosition: SnackPosition.BOTTOM);
      //   return;
      // }

      // Create a new user
      // final user = await _supabase
      //     .from('users')
      //     .insert({'name': name})
      //     .select()
      //     .single();

      // Navigate to HabitTrackerScreen
      // Get.to(() => HabitTrackerScreen(guestName: name, userId: user['id']));
      // Get.toNamed(AppRoutes.home, arguments: {
      //   'guestName': name,
      //   'userId': user['id'],
      // });
    } catch (e) {
      Get.snackbar('Error', 'Sign-Up failed: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signIn() async {
    final email = nameController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter a name and password',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email, // نستخدم نفس الاسم كإيميل وهمي
        password: password,
      );
      final user = response.user;
      if (user == null) {
        Get.snackbar('Error', 'Sign-in failed. No user was found.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      Get.toNamed(AppRoutes.home, arguments: {
        'guestName': email,
        'userId': user.id,
      });

      // Check if the user exists
      // final response = await _supabase
      //     .from('users')
      //     .select('id')
      //     .eq('name', name)
      //     .maybeSingle();

      // if (response == null) {
      //   Get.snackbar('Info', 'User not found. Please sign up.',
      //       snackPosition: SnackPosition.BOTTOM);
      //   return;
      // }

      // Navigate to HabitTrackerScreen
      // Get.to(() => HabitTrackerScreen(guestName: name, userId: response['id']));
      // Get.toNamed(AppRoutes.home, arguments: {
      //   'guestName': name,
      //   'userId': response['id'],
      // });
    } catch (e) {
      // Get.snackbar('Error', 'Sign-In failed: $e',
      //     snackPosition: SnackPosition.BOTTOM);
      Get.snackbar('Error', 'Sign-In failed: Email or Password incorrect',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
