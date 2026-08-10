import 'dart:io';

import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool showSpinner = false;

  final postRef = FirebaseDatabase.instance.ref().child('Posts');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String title = "";
  String description = "";

  final _formKey = GlobalKey<FormState>();

  File? _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future showOptions() async {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: ((context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            height: 170,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text('Upload Photo',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () {
                          // close the options modal
                          Navigator.of(context).pop();
                          // get image from gallery
                          getImageFromGallery();
                        },
                        child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child:const Center(child: Text('Gallery')))),
                    InkWell(
                        onTap: () {
                          // close the options modal
                          Navigator.of(context).pop();
                          // get image from camera
                          getImageFromCamera();
                        },
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(child: Text('Camera'))
                        )),
                  ],
                ),
              ],
            ),
          );
        }));
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();


  String email = "";
  String password = "";

  final formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      blur: 2,
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Colors.indigo,
                  Colors.indigoAccent,
                ])),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
          title: const Text(
            "Create New Account",
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
                  GestureDetector(
                    onTap: (){
                      showOptions();
                    },
                    child: Container(
                        height: 100,
                        width: 100,
                        decoration:  BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.black
                            )
                        ),
                        child: _image != null
                            ? ClipRect(
                          clipBehavior: Clip.antiAlias,
                          child: Image.file(
                            _image!.absolute,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Center(
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.black,
                            size: 30,
                          ),
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 70,
                    child: TextFormField(
                      controller: nameController,
                      cursorColor: Colors.black,
                      maxLength: 15,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: "Full Name",
                        labelStyle: const TextStyle(
                            color: Colors.black38, fontWeight: FontWeight.normal),
                        prefixIcon: const Icon(
                          Icons.person,
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
                      validator: (value) {
                        return value!.isEmpty ? "Enter Full Name" : null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
                            color: Colors.black38, fontWeight: FontWeight.normal),
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
                        return value!.isEmpty ? "Enter correct Email" : null;
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
                            color: Colors.black38, fontWeight: FontWeight.normal),
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
                  const SizedBox(
                    height: 50,
                  ),
                  RoundButton(
                      title: "Register",
                      onPress: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            showSpinner = true;
                          });
                          _auth
                              .createUserWithEmailAndPassword(
                                  email: email.toString().trim(),
                                  password: password.toString().trim())
                              .then((value) {
                            setState(() {
                              showSpinner = false;
                            });
                            toastMessage("User Created Successfully");
                          }).onError((error, stackTrace) {
                            setState(() {
                              showSpinner = false;
                            });
                            toastMessage(error.toString());
                          });

                          try {
                            int date = DateTime.now().millisecondsSinceEpoch;

                            firebase_storage.Reference ref = storage
                                .ref('/blogapp$date');
                            UploadTask uploadTask =
                            ref.putFile(_image!.absolute);
                            await Future.value(uploadTask);
                            var newUrl = await ref.getDownloadURL();
                            final User? user = _auth.currentUser;
                            postRef
                                .child('Post List')
                                .child(date.toString())
                                .set({
                              'uName' : nameController.text.toString(),
                              'pId': date.toString(),
                              'pImage': newUrl.toString(),
                              'pTime': date.toString(),
                              'uEmail': emailController.text.toString(),
                              'uid': user?.uid.toString(),
                            }).then((value) {
                              toastMessage("Post Published");
                              setState(() {
                                showSpinner = false;
                              });
                            }).onError((error, stackTrace) {
                              toastMessage(error.toString());
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            toastMessage(e.toString());
                          }

                        }
                      })
                ],
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
