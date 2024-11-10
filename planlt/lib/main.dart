import 'package:flutter/material.dart';
import 'package:planlt/home.dart';  // تأكد من أن هذا المسار صحيح

void main() {
  runApp(MyApp());  // استبدل Planlt بـ MyApp هنا
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        // تحديد اللون الخلفي العام للتطبيق
        scaffoldBackgroundColor: Color(0xFFF0FFFF),  // لون الخلفية الفاتح
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1E90FF),  // لون رأس اليوم (اليوم في التطبيق)
        ),
        textTheme: TextTheme(
          // تم تعديل 'bodyText1' إلى 'bodyMedium' أو 'bodyLarge'
          bodyMedium: TextStyle(
            color: Color(0xFF696969),  // لون النص في عناصر المهام (لون رمادي داكن)
          ),
        ),
      ),
    );
  }
}
