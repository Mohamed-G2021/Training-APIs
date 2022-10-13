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
  String url = 'https://jsonplaceholder.typicode.com/posts';

  Future getPosts() async {
    var response = await http.get(Uri.parse(url));

    var responseBody = jsonDecode(response.body);

    return responseBody;
  }

  Future addPost() async {
    String url = 'https://jsonplaceholder.typicode.com/posts';

    var response = await http.post(
      Uri.parse(url),
      body: {
        'id': '1',
        'userId': '10',
        'title': 'Hello world to API :)',
      },
    );

    var responseBody = jsonDecode(response.body);

    print(responseBody);

    return responseBody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Posts API'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: ((context, index) => InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                if (snapshot.hasData) {
                                  return SimpleDialog(
                                    title: RichText(
                                      text: TextSpan(
                                          text:
                                              'Post ${snapshot.data[index]['id']} ',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                          children: [
                                            TextSpan(
                                                text:
                                                    'by user ${snapshot.data[index]['userId']}',
                                                style: const TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic))
                                          ]),
                                    ),
                                    contentPadding: const EdgeInsets.all(20),
                                    children: [
                                      Text(
                                        '${snapshot.data[index]['body']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Close"))
                                    ],
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: RichText(
                              text: TextSpan(
                                  text:
                                      'user${snapshot.data[index]['userId']}:',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 23),
                                  children: [
                                    TextSpan(
                                      text: ' ${snapshot.data[index]['title']}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      )),
                  separatorBuilder: ((context, index) => const SizedBox(
                        height: 10,
                      )),
                  itemCount: snapshot.data.length);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addPost();
          },
          backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.add),
        ));
  }
}
