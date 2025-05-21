import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_txt_field.dart';
import 'package:chat_app/widgets/info_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static const String id = 'SignupPage';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
                CustomTextField(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Create password',
                  labelText: 'Password',
                  onChanged: (value) {
                    password = value;
                  },
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Sign Up',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        isLoading = true;
                      setState(() {});
                        await signupUser();
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showSnackBar(context, 'The password is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          showSnackBar(
                            context,
                            'The account already exists for that email.',
                          );
                        } else if (e.code == 'invalid-email') {
                          showSnackBar(
                            context,
                            'The email address is badly formatted.',
                          );
                        } else {
                          showSnackBar(context, 'Error: ${e.message}');
                        }
                      } catch (e) {
                        showSnackBar(context, 'Error: $e');
                      }
                      isLoading = false;
                      setState(() {});
                    } else {
                      showSnackBar(context, 'Please fill in all fields.');
                    }
                  },
                ),
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
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> signupUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
