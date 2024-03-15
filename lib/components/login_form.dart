import 'dart:convert';

import 'package:doc_appointment_app/components/button.dart';
import 'package:doc_appointment_app/main.dart';
import 'package:doc_appointment_app/models/auth_model.dart';
import 'package:doc_appointment_app/providers/dio_provider.dart';
import 'package:doc_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obscurePass = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
                hintText: 'Email Address',
                labelText: 'Email',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.email_outlined),
                prefixIconColor: Config.primaryColor),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.primaryColor,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePass = !obscurePass;
                    });
                  },
                  icon: obscurePass
                      ? const Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.black38,
                        )
                      : const Icon(
                          Icons.visibility_outlined,
                          color: Config.primaryColor,
                        ),
                )),
          ),
          Config.spaceSmall,
          //wrap with consumer...(consumes AuthModel)...
          Consumer<AuthModel>(builder: (context, auth, child) {
            return Button(
                width: double.infinity,
                title: 'Sign In',
                onPressed: () async {
                  final token = await DioProvider()
                      .getToken(_emailController.text, _passController.text);
                  if (token) {
                    // auth.loginSuccess();

                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    final tokenValue = prefs.getString('token') ?? '';

                    if (tokenValue.isNotEmpty && token != '') {
                      final response = await DioProvider().getUser(tokenValue);
                      if (response != null) {
                        setState(() {
                          Map<String, dynamic> appointment = {};
                          final user = json.decode(response); //convert into object..thus it is Mappable(of type Map) by default.....

                          for (var doctorData in user['doctor']) {
                            //if there is appointment return for today, then pass doctor info...
                            if (doctorData['appointments'] != null) {
                              appointment = doctorData; //doctor data with appointments.....
                            
                            }
                          }

                          auth.loginSuccess(user, appointment);
                          MyApp.navigatorKey.currentState!.pushNamed('main');

                        });
                      }
                    }
                  }
                },
                disable: false);
          })
        ],
      ),
    );
  }
}
