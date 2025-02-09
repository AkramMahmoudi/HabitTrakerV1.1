import 'package:flutter/material.dart';
// import 'HabitTrackerScreen.dart';
import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'name_input_controller.dart';

class NameInputScreen extends StatelessWidget {
  final NameInputController controller = Get.put(NameInputController());
  NameInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.passwordController,
              obscureText: true, // إخفاء كلمة المرور
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.signUp(),
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => controller.signIn(),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
