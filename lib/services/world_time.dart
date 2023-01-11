import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';


class WorldTime {
  String location; // location name for UI
  late String time; // the time in that location
  String flag; // url to an asset flag icon
  String url; // location url for api endpoint
  late bool isDaytime; // true or false if day time or not

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {

    try {
      Response response = await get(Uri.http('worldtimeapi.org', '/api/timezone/$url'));
      Map data = jsonDecode(response.body);
      // print(data);

      // get properties from data
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1,3);
      String offset_sign = data['utc_offset'].substring(0,1);

      // create DateTime object
      DateTime now = DateTime.parse(datetime);
      now = offset_sign == '+' ? now.add(Duration(hours: int.parse(offset))):now.subtract(Duration(hours: int.parse(offset)));

      // set the time property
      isDaytime = now.hour > 6 && now.hour < 18 ? true : false;
      time = DateFormat.jm().format(now);
    }
    catch (e) {
      print('Caught error: $e');
      time = 'could not get time data';
    }


  }
}