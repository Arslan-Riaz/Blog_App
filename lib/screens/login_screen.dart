import 'package:blog_app/screens/forgot_password_screen.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = "";
  String password = "";

  final formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        blur: 2,
        inAsyncCall: showSpinner,
        // blur: ,
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
              "Sign In",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Image(
                      image: AssetImage('images/login.png'),
                      height: 150,
                      width: 150,
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
                      height: 30,
                    ),
                    SizedBox(
                      height: 70,
                      child: TextFormField(
                        controller: passwordController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: "Password",
                          labelStyle: const TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.normal),
                          prefixIcon: const Icon(
                            Icons.lock_open_outlined,
                            color: Colors.black,
                          ),
                          suffixIcon: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: _obscureText
                                  ? Icon(
                                      Icons.visibility_off_outlined,
                                      color: Colors.black.withOpacity(0.2),
                                    )
                                  : Icon(
                                      Icons.visibility_outlined,
                                      color: Colors.black.withOpacity(0.2),
                                    )),
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
                          password = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "Enter Password" : null;
                        },
                        obscureText: _obscureText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen()));
                            },
                            child: const Text(
                              "Forgot Password",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    RoundButton(
                        title: "Login",
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              showSpinner = true;
                            });

                            _auth
                                .signInWithEmailAndPassword(
                                    email: email.toString().trim(),
                                    password: password.toString().trim())
                                .then((value) {
                              toastMessage("Login Successfully");
                              setState(() {
                                showSpinner = false;
                              });

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                            }).onError((error, stackTrace) {
                              toastMessage(error.toString());
                              setState(() {
                                showSpinner = false;
                              });
                            });
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ));
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
