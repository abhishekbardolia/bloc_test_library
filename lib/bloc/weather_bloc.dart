import 'dart:async';
import 'package:bloc/bloc.dart';
import '../data/weather_repository.dart';
import './bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final FakeWeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(const WeatherInitial()) {

    on<GetWeather>(getWeather);
    on<GetDetailedWeather>(getDetailWeather);
  }

  getWeather(GetWeather event, Emitter<WeatherState> emit) async{
    try {
      final weather = await weatherRepository.fetchWeather(event.cityName);
      emit(WeatherLoaded(weather));
    } on NetworkError{
      emit(const WeatherError("Couldn't fetch weather. Is the device online?"));
    }
  }

  Future<void> getDetailWeather(GetDetailedWeather event, Emitter<WeatherState> emit) async{
    try {
      final weather =
      await weatherRepository.fetchDetailedWeather(event.cityName);
      emit(WeatherLoaded(weather));
    }on NetworkError{
      emit(const WeatherError("Couldn't fetch weather. Is the device online?"));
    }
  }

  showLoadingEvent(ShowLoadingEvents event, Emitter<WeatherState> emit) {
    emit(const WeatherLoading());
  }
}
