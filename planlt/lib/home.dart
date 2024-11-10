import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'create.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List myDate = [];

  @override
  void initState() {
    super.initState();
    fetchDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // انتظار إغلاق صفحة CreatePage ثم إعادة تحميل البيانات
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePage()),
          );
          fetchDate(); // إعادة تحميل البيانات بعد العودة
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Welcome To",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              "Planlt Weekly Planner",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      DateFormat.yMMMEd().format(DateTime.now()),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: fetchDate,
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: myDate.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = myDate.reversed.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data['title'] ?? 'No Title',
                                style: TextStyle(
                                  fontSize: 20,
                                  decoration: (data['is_competed'] == true)
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(data['description'] ??
                                      'No Description Available')),
                            ],
                          ),
                          Row(
                            children: [
                              Text(DateFormat.yMMMEd()
                                  .format(DateTime.tryParse(
                                          data['created_at'] ?? '') ??
                                      DateTime.now())
                                  .toString()),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CreatePage(iteamData: data,),
                                        ));
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.delete)),
                              Checkbox(
                                value: data['is_competed'] ?? false,
                                onChanged: (val) {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
//get
  Future<void> fetchDate() async {
    var url = Uri.parse(
        'https://virtserver.swaggerhub.com/MENNAFOULY73_1/Doaa_planlt/1.0.0/devices');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      setState(() {
        myDate = json['items'];
      });
      print(myDate);
    } else {
      print("Failed to fetch data: ${response.statusCode}");
    }
  }
}
