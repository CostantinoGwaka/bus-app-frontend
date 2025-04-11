import 'package:app/datasource/data_source.dart';
import 'package:app/datasource/dummy_data_source.dart';
import 'package:app/model/but_route.dart';
import 'package:flutter/material.dart';

class AppDataProvider extends ChangeNotifier {
  final DataSource _dataSource = DummyDataSource();

  Future<BusRoute?> getRouteByCityFromAndCityTo(
    String cityFrom,
    String cityTo,
  ) async {
    return _dataSource.getRouteByCityFromAndCityTo(cityFrom, cityTo);
  }
}
