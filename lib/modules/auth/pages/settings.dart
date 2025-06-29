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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double padding = screenWidth * 0.05;
            double fontSize = screenWidth * 0.06;
            double fontSize2 = screenWidth * 0.03;
            double fontSize3 = screenWidth * 0.04;
            double iconSize = screenWidth * 0.06;
            double scale = screenWidth * 0.002;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text('Hello,',
                            style: TextStyle(
                                fontSize: fontSize,
                                color: themeController.themeMode.value ==
                                        ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black))),
                        Obx(
                          () => Text(
                            mainController.name.value,
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w600,
                                color: themeController.themeMode.value ==
                                        ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Obx(
                      () => ListTile(
                        leading: Icon(
                          Icons.person,
                          size: iconSize,
                        ),
                        title: Text(
                          "Goal",
                          style: TextStyle(
                            fontSize: fontSize3,
                          ),
                        ),
                        trailing: Text(
                          mainController.goal.value,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: fontSize2,
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => ListTile(
                        leading: Icon(
                          Icons.dark_mode,
                          size: iconSize,
                        ),
                        title: Text(
                          "Dark Mode",
                          style: TextStyle(fontSize: fontSize3),
                        ),
                        trailing: Transform.scale(
                          scale: scale,
                          child: Switch(
                            value: themeController.themeMode.value ==
                                ThemeMode.dark,
                            onChanged: (value) {
                              themeController.toggleTheme();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: iconSize,
                      ),
                      title: Text("Logout",
                          style: TextStyle(
                              color: Colors.red, fontSize: fontSize3)),
                      onTap: () {
                        Get.defaultDialog(
                          title: "Logout",
                          middleText: "Are you sure you want to logout?",
                          confirm: TextButton(
                            onPressed: () async {
                              await mainController.logout();
                              Get.offAll(() => CheckUserState());
                            },
                            child: const Text("Yes",
                                style: TextStyle(color: Colors.red)),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
