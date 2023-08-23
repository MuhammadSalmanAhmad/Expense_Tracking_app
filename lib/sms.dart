import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

class SmsWidget extends StatefulWidget {
  const SmsWidget({Key? key}) : super(key: key);

  @override
  State<SmsWidget> createState() => _SmsWidgetState();
}

class _SmsWidgetState extends State<SmsWidget> {
  late String sms = "Your messages will be displayed here";

  final Telephony telephony = Telephony.instance;
  List<SmsMessage> _messages = [];

  final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Expenses/");
  

  List<String> Categories = [
    'food',
    'transport',
    'entertainment',
    'health',
    'shopping',
    'others'
  ];

   @override
  initState(){
  super.initState();
  // _getSmsMessages();
  setState(() {
    _getSmsMessages();
  });
  }

 
  Future<void> _getSmsMessages() async {
    if (await Permission.sms.status.isDenied) {
      await Permission.sms.request();
    }
    if (await Permission.sms.status.isGranted) {
      bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
      debugPrint("Permissions granted: $permissionsGranted");
      List<SmsMessage> messages = await telephony.getInboxSms(
        // columns: [SmsColumn.ID, SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE ],
        // sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );
      print("Number of Messages Read from Phone ${messages.length}");
      print("Data of Messages 1 Read ${messages[0].read}");
      print("Data of Messages 1 Read ${messages[0].read}");

      // print(messages[0].date.toString());  
      _messages = messages;
      // setState(() {
      //   _messages = messages;
      // });
    } else {
      // Handle permission denied
      print("Permission to read SMS messages is denied.");
    }
  }

  // @override
  // void setState(VoidCallback fn) {
  //   // TODO: implement setState
  //   if (mounted) {
  //     telephony.listenIncomingSms(
  //         onNewMessage: (SmsMessage message) {
  //           setState(() {
  //             sms = message.body!;
  //           });
  //         },
  //         listenInBackground: false);
  //     super.setState(fn);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  _getSmsMessages();
                },
                child: const Text('get sms')),
          ),
          Text(sms),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int i) {
                var message = _messages[i];

                return ListTile(
                  title: Text('${message.address} [${message.date}]'),
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
