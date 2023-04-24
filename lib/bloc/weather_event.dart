part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent extends Equatable {}

class GetInitialWeatherDataEvent extends WeatherEvent {
  final String cityName;

  GetInitialWeatherDataEvent(this.cityName);

  @override
  List<Object?> get props => [];
}

class TemperatureConversion extends WeatherEvent {
  final bool switchStatus;

  TemperatureConversion(this.switchStatus);

  @override
  List<Object?> get props => [switchStatus];
}
