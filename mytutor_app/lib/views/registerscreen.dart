import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor_app/views/loginscreen.dart';
import '../constants.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  String pathAsset = 'assets/images/takepic.png';
  var _image;
  bool remember = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  bool _agree = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    print("dispose was called");
    _emailController.dispose();
    _nameController.dispose();
    _numController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth / 1.1;
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        titleSpacing: 6,
        backgroundColor: Colors.transparent,
        elevation:0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom:60),
            child: SizedBox(
              width: ctrwidth,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),

                    const SizedBox(height: 10),
                    Card(
                      child: GestureDetector(
                        onTap: () => {_takePictureDialog()},
                        child: SizedBox(
                        height: screenHeight / 3.5,
                        width: 300,
                        child: _image == null
                            ? Image.asset(pathAsset)
                            : Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ))),
                     ),

                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255,155,36,36)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black,)
                        ),
                        prefixIcon: const Icon(
                          Icons.account_circle,
                          color: Color.fromARGB(255,155,36,36),
                        ),
                        labelText: 'Enter your name',
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid name';
                        }
                        return null;
                      },
                    ),

                  const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255,155,36,36)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black,)
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color.fromARGB(255,155,36,36),
                        ),
                        labelText: 'Email (e.g. ali99@gmail.com)',
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid email';
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);

                        if (!emailValid) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _numController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255,155,36,36)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black,)
                        ),
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Color.fromARGB(255,155,36,36),
                        ),
                        labelText: 'Contact no',
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      minLines: 6,
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255,155,36,36)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black,)
                        ),
                        prefixIcon: const Icon(
                          Icons.home,
                          color: Color.fromARGB(255,155,36,36),
                        ),
                        labelText: 'Address (Street, city, postcode, state)',
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255,155,36,36)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black,)
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color.fromARGB(255,155,36,36),
                        ),
                        labelText: 'Password (at least 6 characters)',
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: screenWidth,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: (){_insertDialog();},
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255,155,36,36),
                          fixedSize: const Size(256, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      child: const Text("Register"),
                      )
                    ),

                    Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already registered?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    const LoginScreen()))
                                      },
                                  child: const Text('LOGIN HERE', style: TextStyle(color: Color.fromARGB(255,155,36,36),)),
                                ),
                              ],
                            ),
                  ]
                ),
              ),
            ),
          )
        ),
      )
    );
  }

  _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    }
  }

  void _insertDialog() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register this information",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _insertDetails();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _insertDetails() {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String phoneno = _numController.text;
    String address = _addressController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor_app/php/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "phoneno": phoneno,
          "address": address,
          "password": password,
          "image": base64Image,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: data['status'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}