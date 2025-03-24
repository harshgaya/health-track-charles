import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/modules/auth/pages/login.dart';
import 'package:fitness_health_tracker/modules/auth/pages/wight_track.dart';
import 'package:fitness_health_tracker/modules/auth/widgets/weight_ruler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../helpers/colors.dart';
import '../../../widgets/rounded_button.dart';
import '../widgets/vitality.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
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
                    label: Text('User Name'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email!';
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email!';
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password!';
                    }
                    if (value.length < 6) {
                      return 'Password must be 6 character!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    label: Text('Confirm Password'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password!';
                    }
                    if (value.length < 6) {
                      return 'Password must be 6 character!';
                    }
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      return 'Password does not match';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(() => SizedBox(
                      width: Get.width - 40,
                      child: mainController.authLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : Row(
                              children: [
                                Expanded(
                                  child: RoundedButton(
                                    function: () async {
                                      if (formKey.currentState!.validate()) {
                                        await mainController.signUpWithEmail(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          context: context,
                                          name: nameController.text,
                                        );
                                      }
                                    },
                                    textColor: 0xFFFFFFFF,
                                    text: 'Sign Up Now',
                                  ),
                                ),
                              ],
                            ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Forgot Password ?',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Color(AppColors.buttonBorderColorLightMode),
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
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(AppColors.buttonBorderColorLightMode),
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => Login());
                            },
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : const Color(
                                        AppColors.buttonBorderColorLightMode),
                          ),
                        ),
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
