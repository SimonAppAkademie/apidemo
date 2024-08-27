import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Quote Generator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String quote = "Wählen Sie eine Kategorie und drücken Sie den Knopf, um ein Zitat zu laden.";
  String author = "";
  String category = "inspiration";
  List<String> categories = ["inspiration", "love", "success", "wisdom", "happiness"];

  Future<void> fetchQuote() async {
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes?category=$category'),
      headers: {'X-Api-Key': '6Vwbo7vAZLInrUZVCLU0Wg==6sgPzHBdbtWdCzd3'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final quoteData = data[0];
        setState(() {
          quote = quoteData['quote'];
          author = quoteData['author'];
        });
      } else {
        setState(() {
          quote = "Kein Zitat für diese Kategorie gefunden.";
          author = "";
        });
      }
    } else {
      setState(() {
        quote = "Fehler beim Laden des Zitats.";
        author = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zufälliges Zitat')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: category,
                onChanged: (String? newValue) {
                  setState(() {
                    category = newValue!;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.capitalize()),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                quote,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              if (author.isNotEmpty)
                Text(
                  '- $author',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: fetchQuote,
                child: Text('Neues Zitat laden'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
