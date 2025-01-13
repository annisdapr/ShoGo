import 'package:flutter/material.dart';
import 'package:shogo/screens/main_screen.dart';
import 'package:shogo/screens/movie_detail_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _removeSplashAfterDelay();
  }

  void _removeSplashAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3)); // Delay 3 detik
    FlutterNativeSplash.remove(); // Hapus splash screen
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShoGo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
      routes: {
        MovieDetailScreen.routeName: (ctx) => const MovieDetailScreen(),
      },
    );
  }
}
