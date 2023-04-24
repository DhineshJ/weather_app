import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/london.dart';

import '../repository/weather_repo.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(this._weatherDataSource) : super(WeatherInitial()) {
    bool switchStatus = false;

    Color? thesms;

    on<GetWeatherDataEvent>((event, emit) async {
      final response =
          await _weatherDataSource.getInitialResponse(event.cityName);
      final data = WeatherReport.fromJson(json.decode(response.body));

      thesms = getThemeData(data.consolidatedWeather[1].theTemp);
      emit(
        CityWeatherState(
            data.title,
            double.parse(data.lattLong.split(',').first),
            double.parse(data.lattLong.split(',').last),
            data.consolidatedWeather[1].weatherStateName,
            thesms,
            data.consolidatedWeather[1].theTemp,
            switchStatus),
      );
    });

    on<TemperatureConversion>((event, emit) {
      switchStatus = event.switchStatus;

      if (((state as CityWeatherState).switchStatus == true)) {
        emit(
          CityWeatherState(
              (state as CityWeatherState).cityName,
              (state as CityWeatherState).minTemp,
              (state as CityWeatherState).maxTemp,
              (state as CityWeatherState).tempType,
              (state as CityWeatherState).color,
              ((state as CityWeatherState).currentTemp * 9 / 5) + 32,
              switchStatus),
        );
      } else {
        emit(
          CityWeatherState(
              (state as CityWeatherState).cityName,
              (state as CityWeatherState).minTemp,
              (state as CityWeatherState).maxTemp,
              (state as CityWeatherState).tempType,
              (state as CityWeatherState).color,
              (state as CityWeatherState).currentTemp,
              switchStatus),
        );
      }
    });
  }

  final WeatherDataSource _weatherDataSource;

  Color? getThemeData(double temp) {
    switch (temp.toInt()) {
      case 8:
      case 10:
        return Colors.white;
      case 74:
      case 75:
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }
}
