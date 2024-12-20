import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task/models/qoute_json_model.dart';
import 'package:task/screens/image_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<QuoteModel> fetchQuote() async {
  final random = Random();
  int randomNumber = random.nextInt(1400) + 1;

  final response =
      await http.get(Uri.parse('https://dummyjson.com/quotes/$randomNumber'));
  var data = jsonDecode(response.body.toString());
  if (response.statusCode == 200) {
    return QuoteModel.fromJson(data);
  } else {
    throw Exception('Failed to load quote');
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Task App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImageScreen(),
                      ),
                    );
                  },
                  child: const Text('Images')),
              const Text(
                'Quote Of The Day',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              FutureBuilder<QuoteModel>(
                future: fetchQuote(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Failed to load quote',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    );
                  } else if (snapshot.hasData) {
                    final quote = snapshot.data!;
                    return Column(
                      children: [
                        Text(
                          quote.quote!,
                          style: const TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '- ${quote.author}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  } else {
                    return const Text('No quote available');
                  }
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    await fetchQuote();
                    setState(() {});
                  },
                  child: const Text('Refresh Quote'))
            ],
          ),
        ),
      ),
    );
  }
}
