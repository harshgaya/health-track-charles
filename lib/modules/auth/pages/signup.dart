import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/modules/auth/widgets/vitality.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/colors.dart';
import '../../../widgets/rounded_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = constraints.maxWidth * 0.05;
        double imageSize = constraints.maxWidth * 0.2;
        double fontSize = constraints.maxWidth * 0.08;
        double textFontSize = constraints.maxWidth * 0.039;

        return Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.05),
                    const Vitality(),
                    SizedBox(height: constraints.maxHeight * 0.03),
                    Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: fontSize * 0.5,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    TextFormField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(label: Text('Full Name')),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(label: Text('Email')),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),
                    TextFormField(
                      controller: passwordController,
                      decoration:
                          const InputDecoration(label: Text('Password')),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    SizedBox(
                      width: constraints.maxWidth,
                      child: Obx(() => mainController.authLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : RoundedButton(
                              function: () async {
                                if (formKey.currentState!.validate()) {
                                  await mainController.signUpWithEmail(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    context: context,
                                    name: nameController.text.trim(),
                                  );
                                }
                              },
                              textColor: 0xFFFFFFFF,
                              text: 'Sign Up',
                            )),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await mainController.googleSignIn(context: context);
                          },
                          child: Image.asset(
                            'assets/auth/Google.png',
                            height: imageSize,
                            width: imageSize,
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.07),
                        Image.asset(
                          'assets/auth/apple.png',
                          height: imageSize,
                          width: imageSize,
                        ),
                        SizedBox(width: constraints.maxWidth * 0.07),
                        InkWell(
                          onTap: () async {
                            await mainController.signInWithFacebook(
                                context: context);
                          },
                          child: Image.asset(
                            'assets/auth/Facebook.png',
                            height: imageSize,
                            width: imageSize,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Align(
                      alignment: Alignment.center,
                      child: Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            fontSize: textFontSize,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : const Color(
                                        AppColors.buttonBorderColorLightMode),
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.back();
                                },
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
