import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/modules/auth/pages/signup.dart';
import 'package:fitness_health_tracker/modules/auth/widgets/vitality.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/colors.dart';
import '../../../widgets/rounded_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Vitality(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                Text(
                  'Please login to continue ',
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(AppColors.grayColor)),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text('User Email'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: Get.width - 40,
                  child: Obx(() => mainController.authLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          children: [
                            Expanded(
                              child: RoundedButton(
                                function: () async {
                                  if (formKey.currentState!.validate()) {
                                    await mainController
                                        .signInWithEmailPassword(
                                            nameController.text.trim(),
                                            passwordController.text.trim(),
                                            context);
                                  }
                                },
                                textColor: 0xFFFFFFFF,
                                text: 'Login Now',
                              ),
                            ),
                          ],
                        )),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    mainController.resetPassword(nameController.text.trim());
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Forgot Password ?',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(
                                  AppColors.buttonBorderColorLightMode)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        await mainController.googleSignIn(context: context);
                      },
                      child: Image.asset(
                        'assets/auth/Google.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Image.asset(
                      'assets/auth/apple.png',
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        await mainController.signInWithFacebook(
                            context: context);
                      },
                      child: Image.asset(
                        'assets/auth/Facebook.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      text: 'Dont have an account? ',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Color(AppColors.buttonBorderColorLightMode),
                      ),
                      children: [
                        TextSpan(
                            text: 'Sign up',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => const SignUp());
                              },
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
