import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/splash_screen.dart';
import 'views/home_screen.dart';
import 'view_models/news_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
      ],
      home: SplashScreen(),
      initialBinding: BindingsBuilder(() {
        // Bind NewsViewModel to the GetX dependency injection system
        Get.put(NewsViewModel());
      }),
    );
  }
}
