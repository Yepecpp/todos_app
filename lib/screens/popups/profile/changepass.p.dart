import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todos_app/components/login/Input.c.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:todos_app/utils/biometric.dart';

class ChangePass {
  String currentPass = '';
  String newPass = '';
  String confirmPass = '';
  String token;
  ChangePass({required this.token});
  final url = '${dotenv.env['HOSTAPI']}/api/v1/auth/password';
  Future<bool> sendReq() async {
    final resp = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "authorization": "Bearer $token"
      },
      body: jsonEncode({
        'password': {
          'old': currentPass,
          'new': newPass,
        }
      }),
    );
    return resp.statusCode == 200;
  }
}

class ChangePassPopup extends StatefulWidget {
  final String token;

  const ChangePassPopup(this.token, {super.key});

  @override
  State<ChangePassPopup> createState() => _ChangePassPopupState();
}

class _ChangePassPopupState extends State<ChangePassPopup> {
  final _formKey = GlobalKey<FormState>();
  final ChangePass changePass = ChangePass(token: '');
  final obscure = [true, true, true];
  final touched = [false, false, false];
  bool isAuth = false;
  Future<T?> showDialogs<T>(bool success) {
    if (success) {
      return showDialog<T>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Your password has been changed'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        },
      );
    } else {
      return showDialog<T>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('There was an error changing your password'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    changePass.token = widget.token;
    bioAuth().then((value) => {
          if (!value)
            {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Biometric Authentication Failed'),
                      content: const Text(
                          'You will not be able to change your password without biometric authentication'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'))
                      ],
                    );
                  }).then(
                ((value) => {
                      Navigator.of(context).pop(),
                    }),
              )
            },
          setState(() {
            isAuth = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    validate() {
      return _formKey.currentState!.validate();
    }

    return !isAuth
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Authenticating...')
                ],
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
              ),
              body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 50),
                        child: const Text(
                          'Change Password',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InputFormText(
                                setInput: (value) {
                                  if (!touched[0]) {
                                    touched[0] = true;
                                  }
                                  changePass.currentPass = value;
                                },
                                validate: validate,
                                obscure: obscure[0],
                                setObscure: (value) {
                                  setState(() {
                                    obscure[0] = value;
                                  });
                                },
                                label: 'Current Password',
                                icon: const Icon(Icons.lock),
                                validator: (value) {
                                  if (!touched[0]) {
                                    return null;
                                  }
                                  if (value!.isEmpty) {
                                    return 'Please enter your current password';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 10),
                            InputFormText(
                                setInput: (value) {
                                  if (!touched[1]) {
                                    touched[1] = true;
                                  }
                                  changePass.newPass = value;
                                },
                                validate: validate,
                                obscure: obscure[1],
                                setObscure: (value) {
                                  setState(() {
                                    obscure[1] = value;
                                  });
                                },
                                label: 'New Password',
                                icon: const Icon(Icons.key),
                                validator: (value) {
                                  if (!touched[1]) {
                                    return null;
                                  }
                                  if (value!.isEmpty) {
                                    return 'Please enter your new password';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 10),
                            InputFormText(
                              setInput: (value) {
                                if (!touched[2]) {
                                  touched[2] = true;
                                }
                                changePass.confirmPass = value;
                              },
                              obscure: obscure[2],
                              validate: validate,
                              label: 'Confirm Password',
                              icon: const Icon(Icons.key_off_rounded),
                              validator: (value) {
                                if (!touched[2]) {
                                  return null;
                                }
                                if (value!.isEmpty) {
                                  return 'Please confirm your new password';
                                }
                                if (value != changePass.newPass) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              setObscure: (value) {
                                setState(() {
                                  obscure[2] = value;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () async {
                                if (!validate()) {
                                  return;
                                }
                                final bool success = await changePass.sendReq();
                                showDialogs(success).then(
                                    (value) => Navigator.of(context).pop());
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  'Send Request',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          );
  }
}
