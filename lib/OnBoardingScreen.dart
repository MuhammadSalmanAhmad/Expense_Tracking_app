import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:xpense_app/utilities/google_icon.dart";

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F6F4),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/phone_app.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff088395),
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 140, vertical: 10),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "SignUpScreen");
              },
              child: Text(
                "Sign Up",
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.bold),
              )),
          OutlinedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 140, vertical: 10),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "SignInScreen");
              },
              child: Text(
                "Sign In",
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
          SizedBox(
            width: 340,
            child: FloatingActionButton.extended(
              heroTag: "facebook",
                icon: const Icon(Icons.facebook, color: Colors.blue,size: 24,),
                
                backgroundColor: Colors.white,
                onPressed: () {},
                label: Text(
                  "Continue with facebook",
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
          ),
              SizedBox(
                width: 340,
                child: FloatingActionButton.extended(
                  heroTag: "google",
                icon: const Icon(GoogleIcon.icon_google,color: Colors.black,size: 20,),
                
                backgroundColor: Colors.white,
                onPressed: () {},
                label: Text(
                  "Continue with Google",
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
              ),
              
        ],
      ),
    );
  }
}
