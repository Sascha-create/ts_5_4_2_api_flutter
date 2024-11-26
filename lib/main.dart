import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MainApp());
}

const dogFactUri = "https://dogapi.dog/api/v2/facts";

Future<String> getDataFromApi(String uri) async {
  final response = await get(Uri.parse(uri));

  return response.body;
}

Future<String> getDogFact() async {
  final jsonString = await getDataFromApi(dogFactUri);

  final jsonObject = jsonDecode(jsonString);


  final String dogFact = jsonObject["data"][0]["attributes"]["body"];

  return dogFact;
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String dogFact = "Noch kein Fakt geladen";

  void getNewFact() async {
    dogFact = await getDogFact();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade800,
          title: const Text("Dog Facts 3000"),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 240, child: Text(dogFact)),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      getNewFact();
                    },
                    child: const Text("Nächster Fakt"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
