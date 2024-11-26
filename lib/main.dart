import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

const dogFactUri = "https://dogapi.dog/api/v2/facts";

Future<String> getDogFact() async {
  final http.Response response = await http.get(Uri.parse(dogFactUri));
  if (response.statusCode == 200) {
    final String data = response.body;

    final Map<String, dynamic> decodedJson = jsonDecode(data);

    final String dogFact = decodedJson["data"][0]["attributes"]["body"];

    return dogFact;
  } else {
    return Future.error("Error");
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String dogFact = "Noch kein Fakt geladen";

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 160,
                ),
                FutureBuilder(
                  future: getDogFact(),
                  builder: (context, snapshot) {
                    String newDogFact = '';
                    if (snapshot.hasError) {
                      newDogFact = 'Es ist ein Fehler aufgetreten!';
                      return Text(
                          style: const TextStyle(color: Colors.red),
                          newDogFact);
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      newDogFact = snapshot.data ?? 'Kein Fakt vorhanden';
                      return Text(newDogFact);
                    }
                    return Text(dogFact);
                  },
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text("Nächster Fakt")),
                const SizedBox(
                  height: 140,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
