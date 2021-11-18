import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_weather_app/search_page.dart';
import 'package:flutter_weather_app/second_page.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:flutter_weather_app/services/weather_service.dart';
import 'models/weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherAppCurrentPage(selectCity: "Bangkok"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherAppCurrentPage extends StatefulWidget {
  WeatherAppCurrentPage({Key? key, this.selectCity}) : super(key: key);
  String? selectCity = "Bangkok";

  @override
  State<WeatherAppCurrentPage> createState() => _WeatherAppCurrentPageState();
}

class _WeatherAppCurrentPageState extends State<WeatherAppCurrentPage> {
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    WeatherService.getCurrentWeather(widget.selectCity);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WeatherService.getCurrentWeather(widget.selectCity),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Weather? weathers = snapshot.data as Weather?;
          if (weathers != null) {
            return _page(weathers);
          } else {
            return const Text("Error");
          }
        } else {
          return Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  _page(Weather weathers) {
    return Stack(
      children: [
        Image.asset(
          _imageCurrentTemp(weathers.weather?[0].main),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        ClipRRect(
          // Clip it cleanly.
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.grey.withOpacity(0.1),
              alignment: Alignment.center,
            ),
          ),
        ),
        Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Weather App"),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchPage()));
              },
              icon: const Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => WeatherAppHistoryPage(
                            selectCity: widget.selectCity,
                          )));
                },
                icon: const Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
            centerTitle: true,
          ),
          body: _body(weathers),
        ),
      ],
    );
  }

  _body(Weather weathers) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_toggleSwitch(), _weatherCurrent(weathers)],
      ),
    );
  }

  _toggleSwitch() {
    return Center(
      child: ToggleSwitch(
        initialLabelIndex: selectIndex,
        totalSwitches: 3,
        labels: const ['Celsius', 'Fahrenheit', 'Kelvin'],
        fontSize: 18,
        minWidth: 150,
        minHeight: 50,
        cornerRadius: 30,
        activeFgColor: Colors.white,
        activeBgColors: const [
          [Colors.cyan],
          [Colors.cyan],
          [Colors.cyan]
        ],
        inactiveFgColor: Colors.white,
        onToggle: (index) {
          setState(() {
            selectIndex = index;
          });
          print("selectIndex =  $selectIndex");
        },
      ),
    );
  }

  _weatherCurrent(Weather weathers) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy kk:mm').format(now);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 75,
        ),
        const SizedBox(
          height: 75,
        ),
        Text(
          "${weathers.name} (${weathers.weather?[0].main})",
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          "update : $formattedDate",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        Text(
          _convertTemporary(weathers.main?.temp),
          style: const TextStyle(
              fontSize: 55, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Row(
          children: [
            // Min
            const Icon(
              Icons.expand_more,
              color: Colors.white,
              size: 25.0,
            ),
            Text(
              _convertTemporary(weathers.main?.tempMin),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(width: 10),

            // Max
            const Icon(
              Icons.expand_less,
              color: Colors.white,
              size: 25.0,
            ),
            Text(
              _convertTemporary(weathers.main?.tempMax),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),

            const SizedBox(width: 10),

            const Icon(
              Icons.thermostat,
              color: Colors.white,
              size: 16.0,
            ),
            Text(
              "${weathers.main?.humidity}%",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  _convertTemporary(double? kel) {
    double K = 273.15;
    double temporary;

    switch (selectIndex) {
      case 0:
        temporary = kel! - K;
        return "${temporary.toStringAsFixed(2)} °C";
      case 1:
        temporary = (kel! - K) * 9 / 5 + 32;
        return "${temporary.toStringAsFixed(2)} °F";
      case 2:
        temporary = kel!;
        return "${temporary.toStringAsFixed(2)} °K";
    }
  }

  _imageCurrentTemp(String? curTemp) {
    switch (curTemp) {
      case "Sunny":
        return "assets/images/sunny.jpg";
      case "Clouds":
        return "assets/images/clouds.jpg";
      case "Drizzle":
        return "assets/images/Drizzle.jpg";
      case "Rain":
        return "assets/images/rainy.jpg";
      case "Mist":
        return "assets/images/mist.jpg";
      default:
        return "assets/images/clear.jpg";
    }
  }
}
