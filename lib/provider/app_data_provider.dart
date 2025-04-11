import 'package:app/datasource/data_source.dart';
import 'package:app/datasource/dummy_data_source.dart';
import 'package:app/model/app_user.dart';
import 'package:app/model/auth_response_model.dart';
import 'package:app/model/bus_model.dart';
import 'package:app/model/bus_reservation.dart';
import 'package:app/model/bus_schedule.dart';
import 'package:app/model/but_route.dart';
import 'package:app/model/reservation_expansion_item.dart';
import 'package:app/model/response_model.dart';
import 'package:app/utils/helper_functions.dart';
import 'package:flutter/material.dart';

class AppDataProvider extends ChangeNotifier {
  final DataSource _dataSource = DummyDataSource();

  List<Bus> _busList = [];
  List<Bus> get busList => _busList;

  List<BusRoute> _routeList = [];
  List<BusRoute> get routeList => _routeList;

  // ignore: prefer_final_fields
  List<BusSchedule> _busscheduleList = [];
  List<BusSchedule> get busScheduleList => _busscheduleList;

  List<BusReservation> _reservationList = [];
  List<BusReservation> get reservationList => _reservationList;

  Future<AuthResponseModel?> login(AppUser user) async {
    final response = await _dataSource.login(user);
    if (response == null) return null;
    await saveToken(response.accessToken);
    await saveLoginTime(response.logInTime);
    await saveExpirationDuration(response.expirationDuration);

    return response;
  }

  Future<BusRoute?> getRouteByCityFromAndCityTo(
    String cityFrom,
    String cityTo,
  ) async {
    return _dataSource.getRouteByCityFromAndCityTo(cityFrom, cityTo);
  }

  Future<List<BusSchedule>> getSchedulesByRouteName(String routeName) async {
    return _dataSource.getSchedulesByRouteName(routeName);
  }

  Future<ResponseModel> addBus(Bus bus) {
    return _dataSource.addBus(bus);
  }

  Future<ResponseModel> addRoute(BusRoute busRoute) {
    return _dataSource.addRoute(busRoute);
  }

  Future<ResponseModel> addSchedule(BusSchedule busSchedule) {
    return _dataSource.addSchedule(busSchedule);
  }

  Future<void> getAllBus() async {
    _busList = await _dataSource.getAllBus();
    notifyListeners();
  }

  Future<void> getAllRoutes() async {
    _routeList = await _dataSource.getAllRoutes();
    notifyListeners();
  }

  Future<ResponseModel> addReservation(BusReservation reservation) {
    return _dataSource.addReservation(reservation);
  }

  Future<List<BusReservation>> getAllReservations() async {
    _reservationList = await _dataSource.getAllReservation();
    notifyListeners();
    return _reservationList;
  }

  Future<List<BusReservation>> getReservationsByMobile(String mobile) {
    return _dataSource.getReservationsByMobile(mobile);
  }

  Future<List<BusSchedule>> getScheduleByRouteName(String routeName) async {
    return _dataSource.getSchedulesByRouteName(routeName);
  }

  Future<List<BusReservation>> getReservationsByScheduleAndDepartureDate(
    int scheduleId,
    String departureDate,
  ) async {
    return _dataSource.getReservationsByScheduleAndDepartureDate(
      scheduleId,
      departureDate,
    );
  }

  List<ReservationExpansionItem> getExapansionItems(
    List<BusReservation> reservationList,
  ) {
    return List.generate(reservationList.length, (index) {
      final reservation = reservationList[index];
      return ReservationExpansionItem(
        header: ReservationExpansionHeader(
          reservationId: reservation.reservationId,
          departureDate: reservation.departureDate,
          schedule: reservation.busSchedule,
          timestamp: reservation.timestamp,
          reservationStatus: reservation.reservationStatus,
        ),
        body: ReservationExpansionBody(
          customer: reservation.customer,
          totalSeatedBooked: reservation.totalSeatBooked,
          seatNumbers: reservation.seatNumbers,
          totalPrice: reservation.totalPrice,
        ),
      );
    });
  }
}
