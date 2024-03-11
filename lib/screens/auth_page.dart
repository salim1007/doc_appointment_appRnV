import 'package:doc_appointment_app/components/login_form.dart';
import 'package:doc_appointment_app/components/sign_up.dart';
import 'package:doc_appointment_app/components/social_button.dart';
import 'package:doc_appointment_app/utils/config.dart';
import 'package:doc_appointment_app/utils/text.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignedIn = true;
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return  Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
        child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.enText['welcome_text']!,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Config.spaceSmall,
                Text(
                  isSignedIn ?
                  AppText.enText['signIn_text']!
                  : AppText.enText['register_text']!,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Config.spaceSmall,
                isSignedIn ?
                const LoginForm()
                : const SignUpForm(),
                Config.spaceSmall,
                isSignedIn ?
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      AppText.enText['forgot_password']!,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ),
                )
                : Container() ,
                const Spacer(),
                Center(
                  child: Text(
                    AppText.enText['social_login']!,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade500
                    ),
                  ),
                ),
                Config.spaceSmall,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialButton(social: 'google'),
                    SocialButton(social: 'facebook'),
                  ],
                ),
                Config.spaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isSignedIn ?
                      AppText.enText['sign_up_text']!
                      : AppText.enText['registered_text']!,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        setState(() {
                          isSignedIn = !isSignedIn;
                        });
                      },
                      child: Text(
                        isSignedIn ?
                        'Sign Up'
                        : 'Sign In',
                         style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
        ),
      )
    );
  }
}

