part of 'weather_bloc.dart';

@immutable
abstract class WeatherState extends Equatable {}

class WeatherInitial extends WeatherState {
  @override
  List<Object?> get props => [];
}

class CityWeatherState extends WeatherState {
  final String cityName;
  final double minTemp;
  final double maxTemp;
  final double currentTemp;
  final String tempType;

  final Color? color;
  final bool switchStatus;
  CityWeatherState(
    this.cityName,
    this.minTemp,
    this.maxTemp,
    this.tempType,
    this.color,
    this.currentTemp, this.switchStatus,
  );

  @override
  List<Object?> get props => [cityName, minTemp, maxTemp, color, currentTemp];
}
