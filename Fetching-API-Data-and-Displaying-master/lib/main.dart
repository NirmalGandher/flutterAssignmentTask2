import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fetching Api Data",
      home: ApiDataScreen(),
    );
  }
}

class ApiDataScreen extends StatefulWidget {
  @override
  _ApiDataScreenState createState() => _ApiDataScreenState();
}

class _ApiDataScreenState extends State<ApiDataScreen> {
  List data = [];
  List filteredData = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  void fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        filteredData = data;
      });
      print(data);
    }
  }

  void filterSearchResults(String query) {
    List tempList = [];
    if (query.isNotEmpty) {
      tempList = data
          .where((item) =>
              item['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        filteredData = tempList;
      });
    } else {
      setState(() {
        filteredData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("API Data with Search Filter"),
          centerTitle: true,
          backgroundColor: Colors.blue),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  labelText: "Search", border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredData[index]['title']),
                  subtitle: Text(filteredData[index]['body']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
