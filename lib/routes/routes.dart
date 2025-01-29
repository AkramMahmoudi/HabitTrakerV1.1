import 'package:get/get.dart';
import '../pages/login/NameInputScreen.dart';
import '../pages/main/HabitTrackerScreen.dart';
import '../pages/task/HabitDetailScreen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/main';
  static const String task = '/task';
  static List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => NameInputScreen(),
    ),
    GetPage(
      name: home,
      page: () => HabitTrackerScreen(),
    ),
    GetPage(
      name: task,
      page: () => HabitDetailScreen(),
    ),
  ];
}
