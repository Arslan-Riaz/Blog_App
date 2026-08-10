import 'dart:io';
import 'package:blog_app/screens/addPost_screen.dart';
import 'package:blog_app/screens/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String search = "";
  TextEditingController searchController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.ref().child('Posts');
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
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
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showSpinner = true;
                    });
                    _auth.signOut().then((value) {
                      setState(() {
                        showSpinner = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OptionScreen()));
                    }).onError((error, stackTrace) {
                      setState(() {
                        showSpinner = false;
                      });
                      toastMessage(error.toString());
                    });
                  },
                  child: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.orange,
            title: const Text(
              "New Blogs",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.transparent,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddPostScreen()));
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.orange,
                        Colors.yellow.shade700,
                      ])),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: searchController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: "Search Blog By Title",
                      labelStyle: const TextStyle(
                          color: Colors.black38, fontWeight: FontWeight.normal),
                      prefixIcon: const Icon(
                        Icons.search,
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
                    ),
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: FirebaseAnimatedList(
                  query: dbRef.child('Post List'),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    String? tempTitle =
                        ((snapshot.value as Map?)?['pTitle'] as String?);
                    if (search.isEmpty) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade400),
                                    child: const Center(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    ((snapshot.value as Map?)?['uEmail']
                                            as String?) ??
                                        'No Email',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                              PopupMenuButton(
                                // offset: Offset(-105, 0),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        bottomRight:

                                        Radius.circular(18),
                                        bottomLeft:
                                        Radius.circular(18))),
                                child:  Center(
                                  child: Icon(
                                    Icons.more_horiz,
                                    size: 20,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                itemBuilder: (BuildContext bc) {
                                  return [
                                    const PopupMenuItem(
                                      value: '/edit',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                            size: 14,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Edit',

                                          ),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: '/pause',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.pause_circle_outlined,
                                            color: Colors.black,
                                            size: 14,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Pause',

                                          ),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: '/delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete_sharp,
                                            color: Colors.black,
                                            size: 14,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Delete',

                                          ),
                                        ],
                                      ),
                                    )
                                  ];
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: FadeInImage.assetNetwork(
                              height: 200,
                              width: double.infinity,
                              placeholder: 'images/blog.png',
                              image: ((snapshot.value as Map?)?['pImage']
                                      as String?) ??
                                  'No Image Found',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    if(isLiked == false){
                                      isLiked = true;
                                    }
                                    else{
                                      isLiked = false;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.thumb_up),
                                iconSize: 20,
                                color: isLiked ? Colors.red : Colors.grey.shade400,
                              ),
                              Icon(
                                Icons.comment,
                                size: 20,
                                color: Colors.grey.shade400,
                              ),
                              Icon(
                                Icons.share,
                                size: 20,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                ((snapshot.value as Map?)?['pTitle']
                                        as String?) ??
                                    'Title',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ((snapshot.value as Map?)?['pDescription']
                                      as String?) ??
                                  'Description',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: const TextStyle(
                                  color: Colors.black38,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    } else if (tempTitle
                        .toString()
                        .toLowerCase()
                        .contains(search.toString().toLowerCase())) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade200),
                                    child: const Center(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    ((snapshot.value as Map?)?['uEmail']
                                            as String?) ??
                                        'No Email',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: FadeInImage.assetNetwork(
                              height: 200,
                              width: double.infinity,
                              placeholder: 'images/blog.png',
                              image: ((snapshot.value as Map?)?['pImage']
                                      as String?) ??
                                  'No Image Found',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                ((snapshot.value as Map?)?['pTitle']
                                        as String?) ??
                                    'Title',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ((snapshot.value as Map?)?['pDescription']
                                      as String?) ??
                                  'Description',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: const TextStyle(
                                  color: Colors.black38,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ))
              ],
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
