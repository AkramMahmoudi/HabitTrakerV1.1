import 'package:flutter/material.dart';
// import 'pages/login/NameInputScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://guzayuciyruruytkinru.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd1emF5dWNpeXJ1cnV5dGtpbnJ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0NDYwNTksImV4cCI6MjA1MzAyMjA1OX0.zNxSAHeb9IiKX5RmmKqjgkZmvCPCG7dqZjJlkB6O_04',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.login, // Set the initial screen
      getPages: AppRoutes.routes,
    );
  }
}
