import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/signup_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_txt_field.dart';
import 'package:chat_app/widgets/info_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String id = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 13, right: 13),
          child: Form(
            key: formKey,
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
                CustomFormTextField(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  onChanged: (value) => email = value,
                ),
                const SizedBox(height: 20),
                CustomFormTextField(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  onChanged: (value) => password = value,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Login',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await _handleLogin();
                    } else {
                      showSnackBar(context, 'Please fill in all fields.');
                    }
                  },
                ),
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
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      await loginUser();
      if (mounted) {
        // Navigate to next screen or show success message
        Navigator.pushNamed(context, HomePage.id);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password' || e.code == 'invalid-email') {
          message = 'Incorrect password or email.';
        } else if (e.code == 'user-disabled') {
          message = 'User account has been disabled.';
        } else if (e.code == 'too-many-requests') {
          message = 'Too many requests. Try again later.';
        } else {
          message = 'Error: ${e.message}';
        }
        showSnackBar(context, message);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
    print('Logged in user: ${user.user?.uid}');
  }
}
