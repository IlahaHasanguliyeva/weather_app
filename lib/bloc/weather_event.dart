part of 'weather_bloc.dart';

sealed class WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final Position position;
  FetchWeather(this.position);
}
