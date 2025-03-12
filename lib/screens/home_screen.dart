import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app_bloc/bloc/weather_bloc.dart';
import 'package:weather_app_bloc/widgets/weather_detail_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int currentTime = DateTime.now().hour;
  String _iconCode(String code) {
    return code.substring(0, 2);
  }

  String welcomingText(int hour) {
    if (hour > 06 || 14 > hour) {
      return 'Good Morning';
    } else if (hour > 14 || 20 > hour) {
      return 'Good Evening';
    } else if (hour > 20 || 06 > hour) {
      return 'Good Night';
    }
    return 'Hello';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, -1.2),
                child: Container(
                  height: 300,
                  width: 500,
                  decoration: BoxDecoration(color: Colors.orange),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is WeatherFailure) {
                    return Center(child: Text('Error'));
                  }
                  if (state is WeatherSuccess) {
                    final Weather weather = state.weather;
                    final iconCode = _iconCode(weather.weatherIcon!);
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '📍 ${weather.areaName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            welcomingText(weather.date!.hour),
                            // 'hello',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset('assets/$iconCode.png'),
                          Center(
                            child: Text(
                              '${weather.temperature!.celsius!.round()}°C',
                              style: TextStyle(
                                fontSize: 55,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              weather.weatherMain!.toUpperCase(),
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          5.verticalSpace,
                          Center(
                            child: Text(
                              DateFormat(
                                'EEEE dd -',
                              ).add_jm().format(state.weather.date!),
                              // 'Friday 16 - 09:41am',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          30.verticalSpace,
                          Row(
                            children: [
                              WeatherDetailCard(
                                image: 'assets/11.png',
                                primaryText: 'Sunrise',
                                secondaryText: DateFormat().add_jm().format(
                                  state.weather.sunrise!,
                                ),
                              ),
                              Spacer(),
                              WeatherDetailCard(
                                image: 'assets/12.png',
                                primaryText: 'Sunset',
                                secondaryText: DateFormat().add_jm().format(
                                  state.weather.sunset!,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Divider(color: Colors.grey, thickness: 0.5),
                          ),
                          Row(
                            children: [
                              WeatherDetailCard(
                                image: 'assets/13.png',
                                primaryText: 'Temp Max',
                                secondaryText:
                                    '${state.weather.tempMax!.celsius!.round()} °C',
                              ),
                              Spacer(),
                              WeatherDetailCard(
                                image: 'assets/14.png',
                                primaryText: 'Temp min',
                                secondaryText:
                                    '${state.weather.tempMin!.celsius!.round()} °C',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
