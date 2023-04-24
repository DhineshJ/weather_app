import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';

class MetricConversion extends StatefulWidget {
  const MetricConversion({super.key});

  @override
  State<MetricConversion> createState() => _MetricConversionState();
}

class _MetricConversionState extends State<MetricConversion> {
  bool switchStatus = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          BlocBuilder<WeatherBloc, WeatherState>(
            buildWhen: (previous, current) {
              if (current is CityWeatherState) {
                switchStatus = current.switchStatus;
              }

              return current is CityWeatherState;
            },
            builder: (context, state) {
              return ListTile(
                title: const Text('Temperature Units'),
                isThreeLine: true,
                subtitle: const Text(
                  'Use metric measurements for temperature units.',
                ),
                trailing: Switch(
                  value: switchStatus,
                  onChanged: (value) {
                    BlocProvider.of<WeatherBloc>(context)
                        .add(TemperatureConversion(value));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

 