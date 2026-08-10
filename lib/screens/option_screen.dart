import 'dart:io';

import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => exit(0),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    RoundButton(title: "Login", onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    }),
                    const SizedBox(
                      height: 50,
                    ),
                    RoundButton(
                        title: "Register",
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
