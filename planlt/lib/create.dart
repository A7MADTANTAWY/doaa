import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreatePage extends StatefulWidget {
  Map? iteamData;
  CreatePage({super.key, this.iteamData});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController titlecon = TextEditingController();
  TextEditingController descrpcon = TextEditingController();

  // Method to handle both POST and PUT requests
  Future<void> handleDataRequest(String method) async {
    if (titlecon.text.isEmpty || descrpcon.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in both fields'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final body = {
      "title": titlecon.text,
      "description": descrpcon.text,
    };

    String url;
    if (method == "POST") {
      url =
          'https://virtserver.swaggerhub.com/MENNAFOULY73_1/Doaa_planlt/1.0.0/devices';
    } else if (method == "PUT") {
      final id = widget.iteamData!["_id"]; // هنا يجب تمرير id الصحيح للمهمة
      url =
          'https://virtserver.swaggerhub.com/MENNAFOULY73_1/Doaa_planlt/1.0.0/devices/$id';
    } else {
      return;
    }

    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(method == "POST"
            ? 'Task created successfully!'
            : 'Task updated successfully!'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context); // إغلاق الصفحة بعد إضافة أو تحديث المهمة بنجاح
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Failed to ${method == "POST" ? "create" : "update"} task.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  bool isEdit = false;

  void initState() {
    final data = widget.iteamData;
    if (widget.iteamData != null) {
      isEdit = true;
      titlecon.text = data!['title'];
      descrpcon.text = data["description"];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Task Title"),
              TextField(
                controller: titlecon,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 15),
              Text("Task Description"),
              TextField(
                controller: descrpcon,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          handleDataRequest("POST"), // ارسال بيانات create
                      child: Text("Create Task"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          handleDataRequest("PUT"), // ارسال بيانات update
                      child: Text("Update Task"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
