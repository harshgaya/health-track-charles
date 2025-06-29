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
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth * 0.05;
          double imageSize = constraints.maxWidth * 0.3;
          double fontSize = constraints.maxWidth * 0.08;
          double textFontSize = constraints.maxWidth * 0.039;

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/auth/heart.png',
                      height: imageSize,
                      width: imageSize,
                    ),
                    Text(
                      'Vitality',
                      style: GoogleFonts.mulish(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                        color: const Color(AppColors.pinkColor),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Text(
                      TextConstants.signupLogin,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: textFontSize,
                        color: const Color(AppColors.grayColor),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.04),
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
                        const SizedBox(width: 20),
                        Expanded(
                          child: RoundedButton(
                            function: () {
                              Get.to(() => const SignUp());
                            },
                            textColor: AppColors.appDarkBackgroundColor,
                            backgroundColor:
                                AppColors.buttonBorderColorDarkMode,
                            text: 'Sign Up',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    InkWell(
                      onTap: () {
                        mainController.signInAnonymously(context: context);
                      },
                      child: Text(
                        'Continue as guest',
                        style: TextStyle(
                          fontSize: textFontSize,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(AppColors.appButtonColorDarkMode)
                              : const Color(AppColors.appButtonColorLightMode),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
