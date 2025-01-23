import 'package:flutter/material.dart';
import 'HabitTrackerScreen.dart';
// import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});
  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  void _signUp() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter a name')));
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User already exists. Please sign in.')),
        );
        return;
      }

      // Create a new user
      final user = await _supabase
          .from('users')
          .insert({'name': name})
          .select()
          .single();

      // Navigate to HabitTrackerScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HabitTrackerScreen(guestName: name, userId: user['id']),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign-Up failed: $e')));
    }
  }

  void _signIn() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter a name')));
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found. Please sign up.')),
        );
        return;
      }

      // Navigate to HabitTrackerScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HabitTrackerScreen(guestName: name, userId: response['id']),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign-In failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up / Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
