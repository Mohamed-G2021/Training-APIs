import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Handling APIs',
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List todos = [];
  String url =
      'https://jsonplaceholder.typicode.com/todos?completed=true&userId=1';

  Future getTodos() async {
    var response = await http.get(Uri.parse(url));

    var responseBody = jsonDecode(response.body);

    setState(() {
      todos.addAll(responseBody);
    });
  }

  @override
  void initState() {
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos API'),
        centerTitle: true,
      ),
      body: todos == null || todos.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: ((context, index) => Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${todos[index]['title']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  )),
              separatorBuilder: ((context, index) => const SizedBox(
                    height: 5,
                  )),
              itemCount: todos.length),
    );
  }
}
