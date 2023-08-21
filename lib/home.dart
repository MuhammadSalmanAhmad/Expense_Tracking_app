import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xpense_app/common_components/bottom_navbar/bottom_navbar_display_Screens/AddExpense.dart';
import 'package:xpense_app/common_components/bottom_navbar/bottom_navbar_display_Screens/DashBoard.dart';
import 'package:xpense_app/common_components/bottom_navbar/bottom_navbar_display_Screens/Profile.dart';
import 'package:xpense_app/common_components/bottom_navbar/bottom_navbar_display_Screens/budget_Screen.dart';
import 'package:xpense_app/common_components/bottom_navbar/bottom_navbar_display_Screens/chat_gpt.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _widgetOptions = <Widget>[
    const MainPanel(),
    const ChatGPT(),
    const AddExpense(),
    const Budget(),
    const Profile()
  ];
  var appbar_title = "Home";
  var selected_index = 0;
  void ItemTapped(int index) {
    setState(() {
      selected_index = index;
      switch (index) {
        case 0:
          {
            appbar_title = 'Home';
          }
          break;
        case 1:
          {
            appbar_title = 'Chat GPT';
          }
          break;
        case 2:
          {
            appbar_title = 'Expense and Income';
          }
          break;
        case 3:
          {
            appbar_title = 'Budget';
          }
          break;
        case 4:
          {
            appbar_title = 'Profile';
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          appbar_title,
          style: GoogleFonts.lato(
              fontSize: 25,
              color: const Color(0XFF455A64),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: _widgetOptions.elementAt(selected_index),
      bottomNavigationBar: CurvedNavigationBar(
        items:  [
          const Icon(Icons.home, size: 30),
          const Icon(Icons.message_outlined, size: 30),
          const Icon(Icons.add, size: 30),
          SizedBox(height: 30,
          child: Image.asset("assets/coins.png"),),
          const Icon(Icons.person, size: 30),
        ],
        onTap: ItemTapped,
        backgroundColor: const Color(0xff088395),
      ),
    );
  }
}
