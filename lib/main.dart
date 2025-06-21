import 'package:app/pages/add_bus_page.dart';
import 'package:app/pages/add_route_page.dart';
import 'package:app/pages/add_schedule_page.dart';
import 'package:app/pages/booking_confirmation_page.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/pages/reservation_page.dart';
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
      title: 'Bus Booking',
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        brightness: Brightness.dark,
      ),
      initialRoute: routeNameHome,
      routes: {
        routeNameHome: (context) => const SearchPageScreen(),
        routeNameSearchResultPage: (context) => const SearchResultPage(),
        routeNameSeatPlanPage: (context) => const SeatPlanPage(),
        routeNameBookingConfirmationPage:
            (context) => const BookingConfirmationPage(),
        routeNameAddBusPage: (context) => const AddBusPage(),
        routeNameAddRoutePage: (context) => const AddRoutePage(),
        routeNameAddSchedulePage: (context) => const AddSchedulePage(),
        routeNameReservationPage: (context) => const ReservationPage(),
        routeNameLoginPage: (context) => const LoginPage(),
      },
    );
  }
}
