import 'dart:convert';
import 'package:flutter_weather_app/models/weatherHistory_model.dart';
import 'package:http/http.dart' as http;

class WeatherHistoryService {

  static Future<WeatherHistory?> getHistoryWeather(String? city) async {
    String  apiKey = "232c830fc3cb3bc8abdb758922091d7a";
    city ?? "Bangkok";

    var url = Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map map = jsonDecode(response.body);

      WeatherHistory weatherHistory  =  WeatherHistory.fromJson(map);
      return weatherHistory;
    }
  }

}