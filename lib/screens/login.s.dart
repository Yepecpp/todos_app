import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/login.m.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/login/Input.c.dart';
import '../bloc/auth_bloc.dart';

// ignore_for_file: prefer_const_constructors
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ILogin login = ILogin(username: '', password: '');
  bool obscure = true;
  bool isLoading = false;
  List<bool> touched = [false, false];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoggedIn) {
          return const Scaffold(
            body: Center(
              child: Text('You are logged in'),
            ),
          );
        }
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.red,
                semanticsLabel: "Loading...",
              ),
            ),
          );
        }
        if (state is AuthInitial) {
          return Scaffold(
            backgroundColor: Colors.grey[300],
            body: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/login/bg.jpg'),
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
                          color: Colors.red[900],
                        ),
                        Text(
                          'Hello User!',
                          style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Welcome to the login screen',
                          style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputFormText(
                                icon: const Icon(Icons.person),
                                setInput: (value) {
                                  if (!touched[0]) {
                                    touched[0] = true;
                                  }
                                  login.username = value;
                                },
                                validate: () {
                                  _formKey.currentState!.validate();
                                },
                                validator: (value) {
                                  if (value!.isEmpty && touched[0]) {
                                    return 'Please enter your username';
                                  }
                                  if (value.length < 3) {
                                    return 'Username must be at least 3 characters';
                                  }
                                  return null;
                                },
                                label: 'Username',
                              ),
                              const SizedBox(height: 20),
                              InputFormText(
                                icon: const Icon(Icons.lock),
                                setInput: (value) {
                                  if (!touched[1]) {
                                    touched[1] = true;
                                  }
                                  login.password = value;
                                },
                                validate: () {
                                  _formKey.currentState!.validate();
                                },
                                validator: (value) {
                                  if (value!.isEmpty & touched[1]) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 3) {
                                    return 'Password must be at least 3 characters';
                                  }
                                  return null;
                                },
                                label: 'Password',
                                obscure: obscure,
                                setObscure: (value) {
                                  setState(() {
                                    obscure = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          state.auth.msg ?? '',
                          style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                              color: (state.auth.status == 200 ||
                                      state.auth.status == 201)
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextButton(
                            onPressed: () async {
                              final valid = _formKey.currentState!.validate();
                              if (!valid) {
                                return;
                              }
                              context
                                  .read<AuthBloc>()
                                  .add(AuthEventLogIn(login: login));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.red[700],
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
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.rubik(
                                    textStyle: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
        return const Scaffold(
          body: Center(
            child: Text('Something went wrong'),
          ),
        );
      },
    );
  }
}
