import 'package:blog_app/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  String email = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      blur: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Colors.orange,
                  Colors.yellow.shade700,
                ])),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
          title: const Text(
            "Forgot Password",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('images/forgot.png'),
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 70,
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: "Email",
                          labelStyle: const TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.normal),
                          prefixIcon: const Icon(
                            Icons.alternate_email_outlined,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2), width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2), width: 1),
                          ),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          return value!.isEmpty && value.contains('@')
                              ? "Enter correct Email"
                              : null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    RoundButton(
                        title: 'Recover Password',
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              showSpinner = true;
                            });
                            _auth
                                .sendPasswordResetEmail(
                                    email: emailController.text.toString())
                                .then((value) {
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage('Email sent');
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage(error.toString());
                            });
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
