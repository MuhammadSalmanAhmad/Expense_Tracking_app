import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:xpense_app/OnBoardingScreen.dart';
import 'package:xpense_app/SignInScreen.dart';
import 'package:xpense_app/SignUpScreen.dart';
import 'package:xpense_app/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  
  );
   await dotenv.load();
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => LaunchScreen(),
      "OnboardingScreen": (context) => const OnboardingScreen(),
      "SignUpScreen": (context) => const SignUpScreen(),
      "SignInScreen": (context) => SignInScreen(),
      "HomeScreen": (context) => const HomeScreen(),
    },
  ));
}

class LaunchScreen extends StatelessWidget {
  LaunchScreen({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;
  
  @override
  
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/money.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              top: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: SizedBox(
                  width: 350,
                  child: Text(
                      "Welcome to xpense app , your Financial lifeline in your hand",
                      style: GoogleFonts.montserrat(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              )),
          Positioned(
              bottom: 50,
              child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff607D8B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "OnboardingScreen");
                      },
                      child: Text(
                        "Get Started",
                        style: GoogleFonts.montserrat(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))))
        ],
      ),
    );
  }
}
