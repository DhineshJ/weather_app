import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/metric_conversion.dart';
import 'package:weather_app/repository/weather_repo.dart';
import 'package:weather_app/views/search.dart';

import 'bloc/weather_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => WeatherBloc(WeatherDataSource())
          ..add(GetInitialWeatherDataEvent("London")),
        child: const MyHomePage(title: 'Flutter Weather'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var themes;
  late bool switchStatus;
  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state is CityWeatherState) {
          switchStatus = state.switchStatus;
          themes = state.color;
        }
      },
      child: MaterialApp(
        home: Material(
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: themes,
                appBar: AppBar(
                  backgroundColor: themes,
                  title: Text(
                    widget.title,
                    style: const TextStyle(color: Colors.black),
                  ),
                  actions: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      BlocProvider<WeatherBloc>.value(
                                        value: BlocProvider.of<WeatherBloc>(
                                            context),
                                        child: const CitySearch(),
                                      )));
                        },
                        icon: const Icon(Icons.search, color: Colors.black)),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      BlocProvider<WeatherBloc>.value(
                                        value: BlocProvider.of<WeatherBloc>(
                                            context)
                                          ..add(TemperatureConversion(
                                              switchStatus)),
                                        child: const MetricConversion(),
                                      )));
                        },
                        icon: const Icon(Icons.settings, color: Colors.black))
                  ],
                ),
                body: BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is CityWeatherState) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Spacer(),
                            SizedBox(
                              height: 100,
                              child: Text(
                                state.cityName,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.currentTemp.toStringAsFixed(2),
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    Text(
                                        "Max ${state.minTemp.toStringAsFixed(2)}"),
                                    Text(
                                        "Min ${state.maxTemp.toStringAsFixed(2)}"),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 75,
                            ),
                            Text(
                              state.tempType,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const Spacer(),
                          ],
                        ),
                      );
                    } else {
                      return const Text('Issue in fetching data');
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
