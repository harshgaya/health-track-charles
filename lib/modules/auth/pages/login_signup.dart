import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/helpers/text_constants.dart';
import 'package:fitness_health_tracker/modules/auth/pages/login.dart';
import 'package:fitness_health_tracker/modules/auth/pages/signup.dart';
import 'package:fitness_health_tracker/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key});

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final mainController = Get.put(MainController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/auth/heart.png',
                height: 109,
                width: 125,
              ),
              Text(
                'Vitality',
                style: GoogleFonts.mulish(
                  fontWeight: FontWeight.bold,
                  fontSize: 44,
                  color: const Color(AppColors.pinkColor),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                TextConstants.signupLogin,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(AppColors.grayColor),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: RoundedButton(
                      function: () {
                        Get.to(() => const Login());
                      },
                      textColor: 0xFFFFFFFF,
                      text: 'Login',
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RoundedButton(
                      function: () {
                        Get.to(() => const SignUp());
                      },
                      textColor: AppColors.appDarkBackgroundColor,
                      backgroundColor: AppColors.buttonBorderColorDarkMode,
                      text: 'Sign Up',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  mainController.signInAnonymously(context: context);
                },
                child: Text(
                  'Continue as guest',
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(AppColors.appButtonColorDarkMode)
                          : const Color(AppColors.appButtonColorLightMode)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
