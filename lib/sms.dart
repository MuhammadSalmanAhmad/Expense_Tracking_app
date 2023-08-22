import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';



class SmsWidget extends StatefulWidget {
  const SmsWidget({Key? key}) : super(key: key);

  @override
  State<SmsWidget> createState() => _SmsWidgetState();
}

class _SmsWidgetState extends State<SmsWidget> {
  

  late String sms;
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Expenses/");

  List<String> Categories = ['food', 'transport', 'entertainment', 'health', 'shopping', 'others'];

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        children: [
          
          ElevatedButton(onPressed: ()async{
            setState(() async{
              var permission = await Permission.sms.status;
            if (permission.isGranted) {
              final messages = await _query.querySms(
                kinds: [
                  SmsQueryKind.inbox,
                  
                ],
                // address: '+254712345789',
                
                count: 10,
                
              );
              debugPrint('sms inbox messages: ${messages.length}');
              String?  testbody=messages[0].body;

              List<String> testbodylist = testbody!.split(' ');
              for (var i in testbodylist) {
                if (Categories.contains(i)) {
                   
                  for (var x in testbodylist){
                    if(x=='Amount'){
                      var amount=testbodylist[testbodylist.indexOf(x)+2];
                      DatabaseReference realref = ref.child(user!.uid).push();
                await realref.set({
                  "category": i,
                  "amount": amount,
                  "Date": DateTime.now().toString()
                });

                    }

                  }
                }
              }
              debugPrint(testbody);
              

              setState(() => _messages = messages);
            } else {
              await Permission.sms.request();
            }
            });
           

          }, child: Text('get sms')),
          Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int i) {
                  var message = _messages[i];
          
                  return ListTile(
            title: Text('${message.sender} [${message.date}]'),
            subtitle: Text('${message.body}'),
                  );
                },
              ),
          )
          
        ],
      ),
    );
  }
}
