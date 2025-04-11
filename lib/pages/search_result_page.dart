import 'package:app/model/bus_schedule.dart';
import 'package:app/model/but_route.dart';
import 'package:app/provider/app_data_provider.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)?.settings.arguments as List?;

    final BusRoute route = argList?[0];
    final String departureDate = argList?[1];
    // final provider = Provider.of<AppDataProvider>(context);
    // provider.getSchedulesByRouteName(route.routeName);

    return Scaffold(
      appBar: AppBar(title: Text("Search Result")),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text(
            'Showing Results for ${route.cityFrom} to ${route.cityTo} on $departureDate',
            style: TextStyle(fontSize: 18),
          ),
          Consumer<AppDataProvider>(
            builder:
                (context, provider, _) => FutureBuilder<List<BusSchedule>>(
                  future: provider.getSchedulesByRouteName(route.routeName),
                  builder: (context, snapshot) {
                    print("snapshot $snapshot");
                    if (snapshot.hasData) {
                      final scheduleList = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            scheduleList
                                .map(
                                  (schedule) => ScheduleItemView(
                                    date: departureDate,
                                    schedule: schedule,
                                  ),
                                )
                                .toList(),
                      );
                    }

                    if (snapshot.hasData) {}

                    if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching data'));
                    }

                    return Text("Please waitng for data...");
                  },
                ),
          ),
        ],
      ),
    );
  }
}

class ScheduleItemView extends StatelessWidget {
  final String date;
  final BusSchedule schedule;
  const ScheduleItemView({
    super.key,
    required this.date,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          routeNameSeatPlanPage,
          arguments: [schedule, date],
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(schedule.bus.busName),
              subtitle: Text(schedule.bus.busType),
              trailing: Text('$currency ${schedule.ticketPrice}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "From: ${schedule.busRoute.cityFrom}",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "To: ${schedule.busRoute.cityTo}",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Departure Date: ${schedule.departureTime}",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "Total Seat: ${schedule.bus.totalSeat}",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
