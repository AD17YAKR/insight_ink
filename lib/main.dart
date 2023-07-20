import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity/connectivity.dart';
import 'views/news_detail_screen.dart';
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
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.blueGrey[75],
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          color: Color.fromRGBO(10, 23, 46, 1.0),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/news_detail', page: () => NewsDetailPage()),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put(NewsViewModel());
      }),
      home: ConnectivityPageWrapper(),
    );
  }
}

class ConnectivityPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkConnectivity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Color.fromRGBO(10, 23, 46, 1.0),);
        } else if (snapshot.data == false) {
          return NoInternetPage();
        } else {
          return SplashScreen();
        }
      },
    );
  }

  Future<bool> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}

class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Internet Connection'),
      ),
      body: const Center(
        child: Text(
          'Please check your internet connection and try again.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
