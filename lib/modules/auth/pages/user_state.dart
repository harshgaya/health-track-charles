import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/modules/auth/pages/dob_track.dart';
import 'package:fitness_health_tracker/modules/auth/pages/goal_track.dart';
import 'package:fitness_health_tracker/modules/auth/pages/height_track.dart';
import 'package:fitness_health_tracker/modules/auth/pages/login_signup.dart';
import 'package:fitness_health_tracker/modules/auth/pages/wight_track.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/user_dashboard.dart';
import 'package:flutter/material.dart';

import '../../../widgets/no_internet.dart';

class CheckUserState extends StatefulWidget {
  @override
  State<CheckUserState> createState() => _CheckUserStateState();
}

class _CheckUserStateState extends State<CheckUserState> {
  StreamSubscription<ConnectivityResult>? _subscription;
  bool _isInternetDisconnected = false;

  @override
  void initState() {
    super.initState();
    _monitorInternet();
  }

  void _monitorInternet() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _goToNoInternetScreen();
      } else if (_isInternetDisconnected) {
        _isInternetDisconnected = false;
        _returnToPreviousScreen(); // Pop No Internet screen when internet returns
      }
    });

    // Check once when the app starts
    Connectivity().checkConnectivity().then((result) {
      if (result == ConnectivityResult.none) {
        _goToNoInternetScreen();
      }
    });
  }

  void _goToNoInternetScreen() {
    _isInternetDisconnected = true;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoInternetScreen()),
    );
  }

  void _returnToPreviousScreen() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  var userData = userSnapshot.data!;
                  String weight = userData['weight'] ?? '';
                  String height = userData['height'] ?? '';
                  String dob = userData['dob'] ?? '';
                  String goal = userData['goal'] ?? '';

                  if (weight.isEmpty) {
                    return const WeightTrack();
                  } else if (height.isEmpty) {
                    return const HeightRuler();
                  } else if (dob.isEmpty) {
                    return const DobTracker();
                  } else if (goal.isEmpty) {
                    return const GoalSelectionPage();
                  } else {
                    return const UserDashboard();
                  }
                } else {
                  return const LoginSignup();
                }
              },
            );
          } else {
            return const LoginSignup();
          }
        },
      ),
    );
  }
}
