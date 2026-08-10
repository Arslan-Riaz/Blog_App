import 'dart:io';
import 'package:blog_app/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
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
                            child: Image.asset(
                              'images/gallery.png',
                              scale: 8,
                            ))),
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
                          child: Image.asset(
                            'images/camera.png',
                            scale: 8,
                          ),
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

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      blur: 2,
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          centerTitle: true,
          title: const Text(
            "Upload Blogs",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        showOptions();
                      },
                      child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey.shade300),
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
                                    color: Colors.white,
                                    size: 70,
                                  ),
                                )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 70,
                    child: TextFormField(
                      controller: titleController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      maxLength: 15,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: "Title",
                        labelStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                            fontWeight: FontWeight.normal),
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
                        title = value;
                      },
                      validator: (value) {
                        return value!.isEmpty ? "Enter Title" : null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    // height: 70,
                    child: TextFormField(
                      controller: descriptionController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                            fontWeight: FontWeight.normal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.2), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.2), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.2), width: 1),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.2), width: 1),
                        ),
                      ),
                      onChanged: (value) {
                        description = value;
                      },
                      validator: (value) {
                        return value!.isEmpty ? "Enter Description" : null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  RoundButton(
                      title: "Upload",
                      onPress: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            showSpinner = true;
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
                              'uName' : user!.displayName.toString(),
                              'pId': date.toString(),
                              'pImage': newUrl.toString(),
                              'pTime': date.toString(),
                              'pTitle': titleController.text.toString(),
                              'pDescription': descriptionController.text.toString(),
                              'uEmail': user.email.toString(),
                              'uid': user.uid.toString(),
                            }).then((value) {
                              toastMessage("Post Published");
                              setState(() {
                                showSpinner = false;
                              });
                              Navigator.pop(context);
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
                      }),
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
