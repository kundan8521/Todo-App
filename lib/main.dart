import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_zip/views/screens/home_screen.dart';
import 'package:todo_app_zip/views/utils/app_theme/app_theme.dart';

import 'controllers/location_controller.dart';
import 'controllers/task_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskController()),
        ChangeNotifierProvider(create: (_) => LocationController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dayTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
