import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future sendToHuggingFace(String message) async {
    final url = Uri.parse(
      "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill",
    );

    final response = await http.post(
      url,
      headers: {"Authorization": "Bearer ${dotenv.env['HUGGINGFACE_API_KEY']}"},
      body: jsonEncode({"inputs": message}),
    );

    log(jsonEncode(response.body).toString(), name: "HuggingFace Response");

    return (response);
  }
}
