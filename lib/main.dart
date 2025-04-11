import 'package:app/pages/search_page.dart';
import 'package:app/pages/search_result_page.dart';
import 'package:app/pages/seat_plan_page.dart';
import 'package:app/provider/app_data_provider.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppDataProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        brightness: Brightness.dark,
      ),
      home: const SearchPageScreen(),
      routes: {
        routeNameHome: (context) => const SearchPageScreen(),
        routeNameSearchResultPage: (context) => const SearchResultPage(),
        routeNameSeatPlanPage: (context) => const SeatPlanPage(),
      },
    );
  }
}
