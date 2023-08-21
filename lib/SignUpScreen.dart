// ignore_for_file: unnecessary_const
import 'package:xpense_app/utilities/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'SignInScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// here I am defining my controllers for all the textfields */
  /// and also defining my user class object */

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //firebase auth instance and firebase realtime databse instance ref defined here

  FirebaseAuth auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Users/");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 70,
                ),
                Row(
                  children: [
                    Text(
                      "Set up your profile",
                      style: GoogleFonts.lato(
                          color: const Color(0XFF455A64),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 70,
                      width:70,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/pen.jpg"),
                      )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/money.jpg"),
                    radius: 100,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  runSpacing: 15,
                  children: [
                    TextFormField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Enter your name",
                        helperStyle:
                            TextStyle(color: Color(0XFF455A64), fontSize: 10),
                        labelText: "Name",
                        labelStyle:
                            TextStyle(color: Color(0XFF455A64), fontSize: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                          borderSide:
                              BorderSide(color: Color(0XFF455A64), width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: "Enter your email",
                        helperStyle:
                            TextStyle(color: Color(0XFF455A64), fontSize: 10),
                        labelText: "Email",
                        labelStyle:
                            TextStyle(color: Color(0XFF455A64), fontSize: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                          borderSide:
                              BorderSide(color: Color(0XFF455A64), width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Enter your password",
                        helperStyle:
                            TextStyle(color: Color(0XFF455A64), fontSize: 10),
                        labelText: "Password",
                        labelStyle:
                            TextStyle(color: Color(0XFF455A64), fontSize: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                          borderSide:
                              BorderSide(color: Color(0XFF455A64), width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        try {
                          await auth
                              .createUserWithEmailAndPassword(
                                  email: emailController.text.toString(),
                                  password: passwordController.text.toString())
                              .then((value) => {
                                    
                                    Navigator.pushNamed(context, 'SignInScreen'),
                                    
                                  });
                          
                          var uid=auth.currentUser!.uid;
                          await ref.child(uid).set({
                            "id": uid,
                            "name": userNameController.value.text,
                            "email": emailController.value.text,
                            "password": passwordController.value.text,
                          });        
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Utilities().show_Message("Account Created");
                        } on FirebaseAuthException catch (e) {
                          String errorMessage;
                          switch (e.code) {
                            case 'weak-password':
                              errorMessage =
                                  "The password provided is too weak.";
                              break;
                            case 'email-already-in-use':
                              errorMessage =
                                  "The account already exists for that email.";
                              break;
                            default:
                              errorMessage =
                                  "An error occurred. Please try again later.";
                              debugPrint(e.toString());
                              break;
                          }
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Utilities().show_Message(errorMessage);
                        } catch (e) {
                          debugPrint(e.toString());
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Utilities().show_Message(
                              "An error occurred. Please try again later.");
                        }
                      }
                    },
                    child: Center(
                      child: Text("Create Account",
                          style: GoogleFonts.abel(
                              fontSize: 20,
                              fontWeight: FontWeight.bold) //TextStyle
                          ),
                    )),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",
                        style: TextStyle(color: Colors.black, fontSize: 15)),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()));
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Color.fromARGB(255, 19, 48, 62),
                              fontSize: 15,
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
