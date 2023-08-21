import 'package:xpense_app/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xpense_app/home.dart';
import 'SignUpScreen.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Sign In",
                  style: GoogleFonts.lato(
                      color: const Color(0XFF455A64),
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 100,
                ),
                Wrap(runSpacing: 10, children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle:
                          TextStyle(color: Color(0XFF455A64), fontSize: 20),
                      hintText: "Enrer your email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      labelStyle:
                          TextStyle(color: Color(0XFF455A64), fontSize: 20),
                      hintText: "Enrer your password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "HomeScreen");
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Color.fromARGB(255, 19, 48, 62),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ))
                ]),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        backgroundColor: const Color(0xff088395),
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await auth
                                .signInWithEmailAndPassword(
                                    email: emailController.text.toString(),
                                    password:
                                        passwordController.text.toString())
                                .then((value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen())));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Utilities().show_Message("User not found");
                            } else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Utilities().show_Message("Wrong password");
                            }
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: Text("Login",
                          style: GoogleFonts.abel(
                              fontSize: 22,
                              fontWeight: FontWeight.bold) //TextStyle
                          )),
                ),
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text(
                          "Sign-Up",
                          style: TextStyle(
                              color: Color.fromARGB(255, 19, 48, 62),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
