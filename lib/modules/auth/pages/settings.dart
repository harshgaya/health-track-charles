import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/controller/theme_controller.dart';
import 'package:fitness_health_tracker/modules/auth/pages/user_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final themeController = Get.put(ThemeController());
  final mainController = Get.put(MainController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello,'),
              Obx(
                () => Text(
                  mainController.name.value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Goal"),
              trailing: Text(
                mainController.goal.value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Obx(
            () => ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: themeController.themeMode.value == ThemeMode.dark
                    ? true
                    : false,
                onChanged: (value) {
                  themeController.toggleTheme();
                  // Get.changeThemeMode(
                  //   value ? ThemeMode.dark : ThemeMode.light,
                  // );
                },
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Add logout logic here
              Get.defaultDialog(
                title: "Logout",
                middleText: "Are you sure you want to logout?",
                confirm: TextButton(
                  onPressed: () async {
                    await mainController.logout();
                    Get.offAll(() => CheckUserState());
                  },
                  child: const Text("Yes", style: TextStyle(color: Colors.red)),
                ),
                cancel: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
