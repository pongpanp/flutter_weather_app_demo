import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_weather_app/services/weatherHistory_service.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'models/weatherHistory_model.dart';

class WeatherAppHistoryPage extends StatefulWidget {
  WeatherAppHistoryPage({Key? key, this.selectCity}) : super(key: key);
  String? selectCity;

  @override
  State<WeatherAppHistoryPage> createState() =>
      _WeatherAppHistoryPagePageState();
}

class _WeatherAppHistoryPagePageState extends State<WeatherAppHistoryPage> {
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    WeatherHistoryService.getHistoryWeather(widget.selectCity);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WeatherHistoryService.getHistoryWeather(widget.selectCity),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WeatherHistory? weatherHistory = snapshot.data as WeatherHistory?;
          if (weatherHistory != null) {
            return Stack(
              children: [
                Image.asset(
                  "assets/images/Drizzle.jpg",
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
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: Text(widget.selectCity!),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _toggleSwitch(),
                        Expanded(
                          child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: weatherHistory.list!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: _weatherCurrent(
                                          weatherHistory, index)),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
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

  _weatherCurrent(weatherHistory, index) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            _imageCurrentTemp(weatherHistory.list?[index].weather?[0].main),
            fit: BoxFit.cover,
            height: 50,
            width: 50,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${ DateFormat('dd MMM yyyy hh:mm').format(weatherHistory.list?[index].dtTxt) }",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  _convertTemporary(weatherHistory.list?[index].main?.temp),
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  const Icon(
                    Icons.expand_more,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  Text(
                    _convertTemporary(
                        weatherHistory.list?[index].main?.tempMin),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                ],),



                // Max

                Row(children: [
                  const Icon(
                    Icons.expand_less,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  Text(
                    _convertTemporary(
                        weatherHistory.list?[index].main?.tempMax),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],),

                Row(children: [
                  const Icon(
                    Icons.thermostat,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  Text(
                    "${weatherHistory.list?[index].main?.humidity}%",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],),


              ],
            ),
          )
        ],
      ),
    );
  }

  _toggleSwitch() {
    return Column(
      children: [
        Center(
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
        )
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

  _imageCurrentTemp(MainEnum? curTemp) {
    switch (curTemp) {
      case MainEnum.RAIN:
        return "assets/images/ic_rainy.png";
      case MainEnum.CLOUDS:
        return "assets/images/ic_clouds.png";
      default:
        return "assets/images/ic_clear.png";
    }
  }
}
