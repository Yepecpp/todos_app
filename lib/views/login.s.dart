import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../interfaces/auth.i.dart';
import '../interfaces/login.i.dart';

// ignore_for_file: prefer_const_constructors
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ILogin login = ILogin(username: '', password: '');
  Auth auth = Auth();
  bool obscure = true;
  bool isLoading = false;
  List<bool> tocuhed = [false, false];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    storage.ready.then((s) {
      login.token = storage.getItem('token');
      login.getAuth().then((value) {
        setState(() {
          auth = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/login/bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.green[900],
                  ),
                  Text(
                    'Hello User!',
                    style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome to the login screen',
                    style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              onChanged: (value) {
                                if (!tocuhed[0]) {
                                  tocuhed[0] = true;
                                }
                                login.username = value;
                                _formKey.currentState!.validate();
                              },
                              validator: (value) {
                                if (value!.isEmpty || tocuhed[0]) {
                                  return 'Please enter your username';
                                }
                                if (value.length < 3) {
                                  return 'Username must be at least 3 characters';
                                }
                                if ((auth.status ?? 0) >= 400) {
                                  return 'Invalid username or password';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                border: InputBorder.none,
                                labelText: 'Username',
                                labelStyle: GoogleFonts.rubik(
                                  textStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                obscureText: obscure,
                                onChanged: (value) {
                                  if (!tocuhed[1]) {
                                    tocuhed[1] = true;
                                  }
                                  _formKey.currentState!.validate();
                                  login.password = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty && tocuhed[1]) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(obscure
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        obscure = !obscure;
                                      });
                                    },
                                  ),
                                  labelText: 'Password',
                                  labelStyle: GoogleFonts.rubik(
                                    textStyle: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(auth.msg ?? ''),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextButton(
                      onPressed: () async {
                        final valid = _formKey.currentState!.validate();
                        if (!valid) {
                          return;
                        }
                        Auth data = await login.login();
                        setState(() {
                          auth = data;
                        });
                        debugPrint(data.msg ?? 'no msg');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Log In',
                            style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          )),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
