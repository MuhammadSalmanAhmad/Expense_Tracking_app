class ResponseModel {
  String response_text;
  ResponseModel({required this.response_text});
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      response_text: json['choices'][0]['text'],
    );
  }
}
