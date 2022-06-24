import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor_app/views/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../models/user.dart';
import '../constants.dart';
import 'mainscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  bool remember = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadPref();
  }
  
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth;
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: ctrwidth,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: const EdgeInsets.fromLTRB(32,32,32,32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: screenHeight / 3.8,
                            width: screenWidth,
                            child: 
                              Image.asset('assets/images/loginlogo.png'),
                          ),
                          const Text(
                            'Welcome back!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height:24),
                          TextFormField(
                            controller: _emailController,
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
                                Icons.email,
                                color: Color.fromARGB(255,155,36,36),
                              ),
                              labelText: 'Enter your email',
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid email';
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
                          
                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
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
                                Icons.lock,
                                color: Color.fromARGB(255,155,36,36),
                              ),
                              labelText: 'Enter your password',
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return "Password must be at least 8 characters";
                              }
                              return null;
                            },//validator
                          ),
                          const SizedBox(height: 15,),
                          Row(
                            children: [
                              Checkbox(
                                value: remember,
                                onChanged: (bool? value) {_onRememberMeChanged(value!);},
                              ),
                              const Text("Remember Me")
                            ],
                          ),
                          const SizedBox(height: 15,),
                          SizedBox(
                            width: screenWidth,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _loginUser,
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255,155,36,36),
                                fixedSize: const Size(256, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Login"),
                            )
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 1,
                            width: screenWidth,
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(5))),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account yet?",
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
                                                  const RegistrationScreen()))
                                    },
                                child: const Text('REGISTER NOW', style: TextStyle(color: Color.fromARGB(255,155,36,36),)),
                              ),
                            ],
                          ),
                        ]
                      )
                    )
                  ]
                )
              )
            )
          )
        )
      ),
    );
  }


  void _saveRemovePref(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String email = _emailController.text;
      String password = _passwordController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value) {
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setBool('remember', true);
        Fluttertoast.showToast(
            msg: "Preference Stored",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      } else {
        await prefs.setString('email', '');
        await prefs.setString('password', '');
        await prefs.setBool('remember', false);
        _emailController.text = "";
        _passwordController.text = "";
        Fluttertoast.showToast(
            msg: "Preference Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Preference Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      remember = false;
    }
  }

  void _onRememberMeChanged(bool value) {
    remember = value;
    setState(() {
      if (remember) {
        _saveRemovePref(true);
      } else {
        _saveRemovePref(false);
      }
    });
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;
    if (remember) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        remember = true;
      });
    }
  }

  void _loginUser() {
    String _email = _emailController.text;
    String _password = _passwordController.text;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(msg: 'Logging in..', max: 100);
      http.post(
          Uri.parse(CONSTANTS.server + "/mytutor_app/php/login_user.php"),
          body: {"email": _email, "password": _password}).then((response) {
            print(response.body);
            var data = jsonDecode(response.body);
            if (response.statusCode == 200 && data['status'] == 'success') {
              User user = User.fromJson(data['data']);
              Fluttertoast.showToast(
                msg: "Success",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16.0);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (content) => const MainScreen()));
            } 
            else {
              Fluttertoast.showToast(
                msg: "Failed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16.0);
            }
          }
      );
    }
  } 
}