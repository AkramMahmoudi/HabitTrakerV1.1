import 'package:get/get.dart';
import '../pages/login/NameInputScreen.dart';
import '../pages/main/HabitTrackerScreen.dart';
import '../pages/task/HabitDetailScreen.dart';
import 'app_routes.dart';

class AppPages {
  // static const String login = '/login';
  // static const String home = '/main';
  // static const String task = '/task';
  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => NameInputScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HabitTrackerScreen(),
    ),
    GetPage(
      name: AppRoutes.task,
      page: () => HabitDetailScreen(),
    ),
  ];
}
