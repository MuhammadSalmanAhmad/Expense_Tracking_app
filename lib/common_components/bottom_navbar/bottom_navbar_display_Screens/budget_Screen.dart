import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xpense_app/common_components/bottom_navbar/bottom_navbar_display_Screens/budget_Screen_components/bottomSheet.dart';

class Budget extends StatefulWidget {
  const Budget({super.key});

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  DatabaseReference reference = FirebaseDatabase.instance.ref('Budget/');
  var auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  late var username = user?.uid;
  late var fetch_reference = reference.child('$username');
  var data = " ";
  
  @override
  void initState() {
    // TODO: implement initState
    fetch_reference.onChildAdded.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        data = snapshot.value.toString();
      });
      print(data);
      print(snapshot.child("Amount").value.toString());
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff088395),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width, 
                        child: FirebaseAnimatedList(
                            query: fetch_reference,
                            itemBuilder: (BuildContext context,
                                DataSnapshot snapshot,
                                Animation<double> animation,
                                int index) {
                              return ListTile(
                                trailing: Text(snapshot.child('Amount').value
                                    .toString()),
                                title: Text(snapshot.child('Category').value.toString()),
                              );
                            })),
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 20),
                            backgroundColor: const Color(0xff088395),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                enableDrag: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) =>
                                    const BudgetBottomSheet());
                          },
                          child: Text(
                            "Create Budget",
                            style: GoogleFonts.abel(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
