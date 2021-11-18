import 'dart:convert';

import 'package:flutter_weather_app/models/weather_model.dart';


import 'package:http/http.dart' as http;

class WeatherService {
  static Future<Weather?> getCurrentWeather(String? city) async {
    String  apiKey = "232c830fc3cb3bc8abdb758922091d7a";
    city ?? "Bangkok";

    var url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map map = jsonDecode(response.body);
      Weather weathers  =  Weather.fromJson(map);
      return weathers;
    }
  }

}