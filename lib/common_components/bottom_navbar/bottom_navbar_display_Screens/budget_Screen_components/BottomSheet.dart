import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BudgetBottomSheet extends StatefulWidget {
  const BudgetBottomSheet({super.key});

  @override
  State<BudgetBottomSheet> createState() => _BudgetBottomSheetState();
}

class _BudgetBottomSheetState extends State<BudgetBottomSheet> {
  List budget_Categories = [
    "Food",
    "Education",
    "Entertainment",
    "Travel",
    "Health",
    "Shopping",
  ];
  List assets = [
    "assets/cutlery.png",
    "assets/education.png",
    "assets/entertainment.png",
    "assets/airplane.png",
    "assets/healthcare.png",
    "assets/trolley.png"
  ];

  final BudgetController = TextEditingController();
  var category = " ";

  DatabaseReference budget_ref = FirebaseDatabase.instance.ref("Budget/");
  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    budget_Categories.length,
                    (index) => GestureDetector(
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: AssetImage(assets[index]),
                                )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                budget_Categories[index],
                                style: GoogleFonts.abel(
                                    fontSize: 20,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onTap: () {
                            debugPrint(budget_Categories[index]);
                            setState(() {
                              category = budget_Categories[index];
                            });
                          },
                        )),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: BudgetController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.money),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: "Enter Amount"),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                  backgroundColor: const Color(0xff088395),
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onPressed: () async {
                  DatabaseReference ref = budget_ref.child(user!.uid).push();
                  await ref.set({
                    "Category": category,
                    "Amount": BudgetController.text,
                  });
                },
                child: Text(
                  "SAVE",
                  style: GoogleFonts.abel(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
          ],
        ));
  }
}
