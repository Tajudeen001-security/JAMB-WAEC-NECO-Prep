import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/constants.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const JambWaecNecoApp());
}

class JambWaecNecoApp extends StatelessWidget {
  const JambWaecNecoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JAMB WAEC NECO Prep',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
