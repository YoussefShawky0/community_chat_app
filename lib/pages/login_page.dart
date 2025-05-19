import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/signup_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_txt_field.dart';
import 'package:chat_app/widgets/info_title.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String id = 'LoginPage';
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
            InfoTitle(title: 'Login'),
            const SizedBox(height: 15),
            CustomTextField(hintText: 'Enter your email', labelText: 'Email'),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Enter your password',
              labelText: 'Password',
            ),
            const SizedBox(height: 30),
            CustomButton(text: 'Login'),
            const SizedBox(height: 15),
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
                    Navigator.pushNamed(context, SignupPage.id);
                  },
                  child: Text(
                    ' Sign Up',
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
