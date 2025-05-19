import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_txt_field.dart';
import 'package:chat_app/widgets/info_title.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});
  static const String id = 'SignupPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 70.0, left: 13, right: 13),
        child: ListView(
          children: [
            Image.asset(
              'assets/images/scholar.png',
              width: 200,
              height: 200,
              fit: BoxFit.fitHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Scholar Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            InfoTitle(title: 'Create Account'),
            const SizedBox(height: 15),
            CustomTextField(hintText: 'Enter your email', labelText: 'Email'),
            const SizedBox(height: 20),
            CustomTextField(hintText: 'Create password', labelText: 'Password'),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Confirm password',
              labelText: 'Confirm Password',
            ),
            const SizedBox(height: 30),
            CustomButton(text: 'Sign Up'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the signup page
                    Navigator.pop(context);
                  },
                  child: Text(
                    ' Login',
                    style: TextStyle(
                      color: Color(0xFFC7EDE6),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
