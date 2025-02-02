import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_traffic_control_app/components/my_button.dart';
import 'package:smart_traffic_control_app/components/my_scrollbar.dart';
import 'package:smart_traffic_control_app/components/my_textfield.dart';
import 'package:smart_traffic_control_app/constants/router_constants.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';
import 'package:smart_traffic_control_app/constants/text_constants.dart';

import '../services/auth_service.dart';
import 'home_page.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * (topContainerPercentage + 0.2),
              color: primaryHeaderColor,
              child: const Center(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(appTitle, style: TextStyle(fontSize: 45.0, color: primaryTextColor, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Welcome!', style: TextStyle(fontSize: 35.0, color: primaryTextColor, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.8 - topContainerPercentage),
              child: MyScrollbar(
                  child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(35.0, 30.0, 0.0, 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Log in',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: primaryTextColor,
                                )),
                          ],
                        ),
                      ),
                      MyTextField(controller: emailController, hintText: 'E-mail', obscureText: false, hasValidation: true),
                      MyTextField(controller: passwordController, hintText: 'Password', obscureText: true, isPassword: true, hasValidation: true),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40.0, 15.0, 35.0, 20.0),
                        child: Column(children: [
                          const Row(
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: placeholderTextColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Register ',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: placeholderTextColor,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'here',
                                  style: const TextStyle(fontFamily: fontFamily, color: Colors.blue, fontSize: 15.0),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushNamed(registerPageRoute);
                                    },
                                ),
                              ),
                              const Text(
                                '!',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: placeholderTextColor,
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                      const SizedBox(height: 15),
                      MyButton(
                          buttonColor: utilityButtonColor,
                          textColor: buttonTextColor,
                          buttonText: 'Log in',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var loginResponse = await AuthService.login(emailController.text, passwordController.text, ref);
                              if (context.mounted) {
                                if (loginResponse == AuthResponse.success) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Logged in successfully!'),
                                    duration: Duration(seconds: 2),
                                  ));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePage()),
                                  );
                                } else if (loginResponse == AuthResponse.invalidCredentials) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Invalid credentials!'),
                                    duration: Duration(seconds: 2),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('An error occurred'),
                                    duration: Duration(seconds: 2),
                                  ));
                                }
                              }
                            }
                          }),
                      MyButton(
                          buttonColor: importantUtilityButtonColor,
                          textColor: buttonTextColor,
                          borderColor: buttonTextColor,
                          buttonText: 'Forgot Password',
                          onPressed: () {
                            // AuthService.forgotPassword(emailController.text, ref);
                          }),
                    ],
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
