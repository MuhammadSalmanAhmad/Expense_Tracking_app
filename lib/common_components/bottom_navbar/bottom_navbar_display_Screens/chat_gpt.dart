import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:xpense_app/common_components/bottom_navbar/bottom_navbar_display_Screens/chatgptComponents/ResponseModel.dart';

class ChatGPT extends StatefulWidget {
  const ChatGPT({super.key});

  @override
  State<ChatGPT> createState() => _ChatGPTState();
}

class _ChatGPTState extends State<ChatGPT> {
  String message = "Hello";
  var prompt = TextEditingController();
  String response = "Hello";
  ResponseModel ? responseModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 149, 195, 219),
                  borderRadius: BorderRadius.circular(20)),
              height: 400,
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  message,
                  style: GoogleFonts.lato(
                      color: const Color(0XFF455A64),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Flexible(
                    child: TextFormField(
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: prompt,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Enter your message here"),
                        )),
                  ),
                ),
                IconButton(
                    onPressed: ()  {
                       CompletionFunction();
                     
                    },
                    icon: const Icon(Icons.send))
              ],
            )
          ],
        ),
      ),
    );
  }

  CompletionFunction() async {
  try {
    var url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['token']}'
        },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': prompt.text,
          'max_tokens': 250,
          'temperature': 0.7, // Try adjusting temperature value
          'top_p': 1,
        }));

    print("Request: ${response.request}");
    debugPrint("Response Status Code: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}");
    print("Response Headers: ${response.headers}");

    if (response.statusCode == 200) {
      setState(() {
        responseModel =  ResponseModel.fromJson(jsonDecode(response.body));
        message = responseModel!.response_text;
        debugPrint(message);
      });
    } else {
      throw Exception('Failed to Response.');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to create album: $e');
  }
}
}