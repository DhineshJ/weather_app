import 'dart:convert';

import 'package:http/http.dart';

import '../mocks/mocksRes.dart';

class WeatherDataSource {
  Future<Response> getInitialResponse(String cityName) async {
    switch (cityName.toLowerCase().trim()) {
      case "london":
        return Response(json.encode(init_mock), 200);
      case "chicago":
        return Response(json.encode(chicagoMock), 200);
      case "chennai":
        return Response(json.encode(chennai_mock), 200);
      case "losangels":
        return Response(json.encode(losAngels_mock), 200);
      default:
        return Response(json.encode(init_mock), 200);
    }
  }
}
