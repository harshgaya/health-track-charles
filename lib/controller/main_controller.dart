import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/modules/auth/pages/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/auth/pages/wight_track.dart';

class MainController extends GetxController {
  RxBool authLoading = false.obs;
  RxString name = ''.obs;
  RxString goal = ''.obs;
  RxString exerciseDays = ''.obs;
  RxBool addingWater = false.obs;
  RxInt userWeight = 0.obs;
  RxBool valueChanged = false.obs;

  Future<void> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required BuildContext context}) async {
    try {
      authLoading.value = true;
      final FirebaseAuth _auth = FirebaseAuth.instance;

      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "name": name.trim(),
        "email": email.trim(),
        "dob": "",
        "weight": "",
        "height": "",
        "exercise_days": "",
        "goal": "",
        "user_id": FirebaseAuth.instance.currentUser!.uid,
        "created_at": FieldValue.serverTimestamp(),
      });
      authLoading.value = false;
      Get.to(() => const WeightTrack());
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Signup Successful!")),
      // );
      // Navigate to Dashboard or Login Page
    } catch (e) {
      authLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> googleSignIn({required BuildContext context}) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        String name = user.displayName ?? "No Name";
        String email = user.email ?? "No Email";

        await FirebaseFirestore.instance.collection("users").doc(user.uid).set(
            {
              "name": name.trim(),
              "email": email.trim(),
              "dob": "",
              "weight": "",
              "height": "",
              "exercise_days": "",
              "goal": "",
              "user_id": user.uid,
              "created_at": FieldValue.serverTimestamp(),
            },
            SetOptions(
                merge: true)); // Merging to avoid overwriting existing data
      }

      authLoading.value = false;
      Get.to(() => const WeightTrack());

      print("✅ Google Sign-In Successful: ${user!.displayName}");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> signInAnonymously({required BuildContext context}) async {
    try {
      authLoading.value = true;
      final FirebaseAuth _auth = FirebaseAuth.instance;

      await _auth.signInAnonymously();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "name": "",
        "email": "",
        "dob": "",
        "weight": "",
        "height": "",
        "exercise_days": "",
        "goal": "",
        "user_id": FirebaseAuth.instance.currentUser!.uid,
        "created_at": FieldValue.serverTimestamp(),
      });
      authLoading.value = false;
      Get.to(() => const WeightTrack());
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Signup Successful!")),
      // );
      // Navigate to Dashboard or Login Page
    } catch (e) {
      authLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> signInWithFacebook({required BuildContext context}) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final AccessToken? accessToken = loginResult.accessToken;

        if (accessToken != null) {
          // Use the correct token for Firebase Authentication
          final OAuthCredential credential =
              FacebookAuthProvider.credential(accessToken.tokenString);

          // Sign in to Firebase
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);

          // Save user data in Firestore
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .set({
            "name": userCredential.user!.displayName ?? "",
            "email": userCredential.user!.email ?? "",
            "dob": "",
            "weight": "",
            "height": "",
            "exercise_days": "",
            "goal": "",
            "user_id": userCredential.user!.uid,
            "created_at": FieldValue.serverTimestamp(),
          });

          Get.to(() => const WeightTrack());
        }
      } else {
        print("Facebook login failed: ${loginResult.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Facebook login failed: ${loginResult.message}")),
        );
      }
    } catch (e) {
      print("Error during Facebook login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      authLoading.value = true;
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => CheckUserState());
    } catch (e) {
      authLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Success",
        "Password reset email sent! Check your inbox.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("❌ Reset Password Error: $e");
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateUserData(
      {required String field, required String value}) async {
    try {
      authLoading.value = true;
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (userId.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {
            field: value,
          },
        );
      }
      Get.offAll(() => CheckUserState());
    } catch (e) {
      print("Error updating user data: $e");
    } finally {
      authLoading.value = false;
    }
  }

  Future<void> getUserName() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) {
        goal.value = value.get('goal');
        exerciseDays.value = value.get('exercise_days') ?? '';
        if (value.get('name').isNotEmpty) {
          name.value = value.get('name');
        } else {
          name.value = 'Guest';
        }
      });
    } catch (e) {}
  }

  Future<void> addWaterTea(
      {required bool water,
      required int value,
      required String item,
      required BuildContext context,
      required String time}) async {
    try {
      addingWater.value = true;
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userFoodDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('water')
          .doc(time);

      await userFoodDoc.set(
          {'time': time, item.toLowerCase(): FieldValue.increment(1)},
          SetOptions(merge: true));

      // if (water) {
      //   await userFoodDoc.set({'time': time, 'water': FieldValue.increment(1)},
      //       SetOptions(merge: true));
      // } else {
      //   await userFoodDoc.set({'time': time, 'tea': FieldValue.increment(1)},
      //       SetOptions(merge: true));
      // }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Upload Successful!")),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload Failed!")),
      );
    } finally {
      addingWater.value = false;
    }
  }

  Future<void> removeWaterTea(
      {required String item,
      required BuildContext context,
      required String time}) async {
    try {
      addingWater.value = true;
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userFoodDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('water')
          .doc(time);

      await userFoodDoc.set({item.toLowerCase(): FieldValue.increment(-1)},
          SetOptions(merge: true));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload Failed!")),
      );
    } finally {
      addingWater.value = false;
    }
  }

  Future<Map<String, String>> getBedTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? bedTime = sharedPreferences.getString('bed-time');
    String? alarmTime = sharedPreferences.getString('alarm-time');
    if (bedTime != null && alarmTime != null) {
      return {'bedTime': bedTime, 'alarmTime': alarmTime};
    } else {
      return {'bedTime': '23:00', 'alarmTime': '06:00'};
    }
  }

  Future<void> saveBedTime(
      {required String bedTime, required String alarmTime}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('bed-time', bedTime);
    sharedPreferences.setString('alarm-time', alarmTime);
    double sleepDuration = calculateSleepDuration(bedTime, alarmTime);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('sleep')
        .doc()
        .set({
      'created_at': FieldValue.serverTimestamp(),
      'bed-time': bedTime,
      'alarm-time': alarmTime,
      'sleep-duration': sleepDuration,
    }, SetOptions(merge: true));
  }

  double calculateSleepDuration(String bedTime, String alarmTime) {
    DateFormat format = DateFormat("HH:mm");
    DateTime bedDateTime = format.parse(bedTime);
    DateTime alarmDateTime = format.parse(alarmTime);

    if (alarmDateTime.isBefore(bedDateTime)) {
      alarmDateTime = alarmDateTime.add(Duration(days: 1));
    }

    Duration sleepDuration = alarmDateTime.difference(bedDateTime);
    double totalHours = sleepDuration.inMinutes / 60.0;

    return double.parse(totalHours.toStringAsFixed(1));
  }

  Future<void> saveStepStandCount(
      {required int steps, required int stand}) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String todayTimestamp = DateFormat('dd-MM-yyyy').format(DateTime.now());

    DocumentReference userFoodDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('steps')
        .doc(todayTimestamp);

    await userFoodDoc.set(
        {'time': todayTimestamp, 'steps': steps, 'stand': stand},
        SetOptions(merge: true));
  }

  void getUserWeight() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      userWeight.value = int.tryParse(value.get('weight')) ??
          double.tryParse(value.get('weight'))?.toInt() ??
          0;
    });
  }

  Future<void> saveExerciseMinute({
    required dynamic minutes,
  }) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String todayTimestamp = DateFormat('dd-MM-yyyy').format(DateTime.now());

    DocumentReference userFoodDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('steps')
        .doc(todayTimestamp);

    final docSnapshot = await userFoodDoc.get();
    dynamic previousMinutes = 0;

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      if (data.containsKey('exercise')) {
        previousMinutes = data['exercise'] ?? 0;
      }
    }

    int totalMinutes = previousMinutes + minutes;

    await userFoodDoc.set({
      'time': todayTimestamp,
      'exercise': totalMinutes,
    }, SetOptions(merge: true));
  }

  Future<void> addNewItem({
    required String name,
    required BuildContext context,
    required String time,
  }) async {
    try {
      addingWater.value = true;
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userFoodDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot docSnapshot = await userFoodDoc.get();
      List<dynamic> existingItems = [];

      if (docSnapshot.exists && docSnapshot.data() != null) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        if (data['items'] != null && data['items'] is List) {
          existingItems = List.from(data['items']);
        }
      }

      // Check for name clash (case-insensitive comparison)
      bool nameExists = existingItems.any((item) =>
          item['name'].toString().toLowerCase() == name.toLowerCase());

      if (nameExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Item with the same name already exists!")),
        );
        return;
      }

      // Add new item
      Map<String, dynamic> newItem = {
        'name': name,
        'image1': '',
        'image2': '',
        'time': Timestamp.now(),
      };

      existingItems.add(newItem);

      await userFoodDoc.update({'items': existingItems});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload Failed!")),
      );
    } finally {
      addingWater.value = false;
    }
  }
}
