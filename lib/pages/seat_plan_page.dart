import 'package:app/customwidgets/seat_plan_view.dart';
import 'package:app/model/bus_schedule.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/helper_functions.dart';
import 'package:flutter/material.dart';

class SeatPlanPage extends StatefulWidget {
  const SeatPlanPage({super.key});

  @override
  State<SeatPlanPage> createState() => _SeatPlanPageState();
}

class _SeatPlanPageState extends State<SeatPlanPage> {
  late BusSchedule schedule;
  late String departureDate;
  int totalSeatBooked = 0;
  String bookedSeatNumbers = '';
  List<String> selectedSeats = [];
  bool isFirst = true;
  bool isDataLoading = true;
  ValueNotifier<String> selectedSeatStringNotifier = ValueNotifier('_value');

  @override
  void didChangeDependencies() {
    final argsList = ModalRoute.of(context)?.settings.arguments as List?;
    schedule = argsList?[0];
    departureDate = argsList?[1];
    _getData();
    super.didChangeDependencies();
  }

  _getData() async {
    final resList = [];
    // final resList = await Provider.of<AppDataProvider>(
    //   context,
    //   listen: false,
    // ).getReservationsByScheduleAndDepartureDate(
    //   schedule.scheduleId!,
    //   departureDate,
    // );
    setState(() {
      isDataLoading = false;
    });
    List<String> seats = [];
    for (final res in resList) {
      // totalSeatBooked += res.totalSeatBooked;
      seats.add((res.seatNumbers));
    }
    bookedSeatNumbers = seats.join(',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seat Plan")),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: seatBookedColor,
                        ),
                        const SizedBox(width: 10),
                        const Text("Booked", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: seatAvailableColor,
                        ),
                        const SizedBox(width: 10),
                        const Text("Available", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: selectedSeatStringNotifier,
              builder:
                  (context, value, _) => Text(
                    "Selected: $value",
                    style: const TextStyle(fontSize: 16),
                  ),
            ),
            if (!isDataLoading)
              Expanded(
                child: SingleChildScrollView(
                  child: SeatPlanView(
                    totalSeat: schedule.bus.totalSeat,
                    bookedSeatNumbers: bookedSeatNumbers,
                    totalSeatBooked: totalSeatBooked,
                    isBusinessClass: schedule.bus.busType == busTypeACBusiness,
                    onSeatSelected: (value, seat) {
                      if (value) {
                        selectedSeats.add(seat);
                      } else {
                        selectedSeats.remove(seat);
                      }
                      selectedSeatStringNotifier.value = selectedSeats.join(
                        ',',
                      );
                    },
                  ),
                ),
              ),
            OutlinedButton(
              onPressed: () {
                if (selectedSeats.isEmpty) {
                  showMsg(context, 'Please select your seat first');
                  return;
                }
                Navigator.pushNamed(
                  context,
                  routeNameBookingConfirmationPage,
                  arguments: [
                    departureDate,
                    schedule,
                    selectedSeatStringNotifier.value,
                    selectedSeats.length,
                  ],
                );
              },
              child: const Text('NEXT'),
            ),
          ],
        ),
      ),
    );
  }
}
