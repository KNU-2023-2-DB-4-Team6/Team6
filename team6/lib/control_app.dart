import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:team6/class/models.dart';

final viewmodel = ChangeNotifierProvider<ViewModel>((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  final serverUrl = 'http://192.168.97.100:8080';
  LatLng myLocation = const LatLng(35.8862, 128.6101);
  List<Event> events = <Event>[];
  List<Marker> markers = <Marker>[];
  List<CVS> stores = <CVS>[];
  List<String> possibleProducts = <String>[];
  CVS selectedStore = CVS();

  Future<int> login(String id, String pw, String state) async {
    final Map<String, dynamic> data = {
      "id": id,
      "password": pw,
      "state": state,
    };

    try {
      var response = await http.post(Uri.parse("$serverUrl/login"),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        if (response.body == "success") {
          return 1;
        } else if (response.body == "password incorrect") {
          return 0;
        } else if (response.body == "id incorrect") {
          return -1;
        }
      } else {
        return -2;
      }
    } catch (e) {
      return -3;
    }
    return -4;
  }

  Future<int> signUp(
      String id, String pw, String state, double locX, double locY) async {
    final Map<String, dynamic> data = {
      "id": id,
      "password": pw,
      "state": state,
      "loc_x": locX,
      "loc_y": locY,
    };
    try {
      var response = await http.post(Uri.parse("$serverUrl/signUp"),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        if (response.body == "error") {
          return -1;
        } else if (response.body == "success") {
          return 1;
        } else {
          return -2;
        }
      } else {
        return -3;
      }
    } catch (e) {
      return -3;
    }
  }

  Future<int> cvsLocation() async {
    try {
      var response = await http.get(Uri.parse("$serverUrl/mainPage/allStore"),
          headers: {'Content-Type': 'application/json'});
      stores = [];
      markers = [];
      for (var store in jsonDecode(response.body) as List) {
        CVS newStore = CVS();
        newStore.id = store['store_id'];
        newStore.locX = double.parse(store['loc_x']);
        newStore.locY = double.parse(store['loc_y']);
        Marker newMarker = Marker(
          markerId: MarkerId(markers.length.toString()),
          position: LatLng(newStore.locY!, newStore.locX!),
        );
        stores.add(newStore);
        markers.add(newMarker);
      }
      notifyListeners();
      return 1;
    } catch (e) {
      return -2;
    }
  }

  Future<int> eventList() async {
    try {
      var response = await http.get(
          Uri.parse("$serverUrl/mainPage/allIngEvent"),
          headers: {'Content-Type': 'application/json'});
      events = [];
      for (var event in jsonDecode(utf8.decode(response.bodyBytes)) as List) {
        Event newEvent = Event();
        newEvent.name = event['eventName'];
        newEvent.estart = event['start'];
        newEvent.eend = event['end'];
        newEvent.policy = event['policy'];
        events.add(newEvent);
      }
      print(events.length);
      print(markers.length);
      print(stores.length);
      notifyListeners();
      return 1;
    } catch (e) {
      return -2;
    }
  }

  Future<int> searchList(String keyword) async {
    try {
      var response = await http.get(
          Uri.parse("$serverUrl/search?keyword=$keyword"),
          headers: {'Content-Type': 'application/json'});
      possibleProducts = [];
      for (var product in jsonDecode(utf8.decode(response.bodyBytes)) as List) {
        possibleProducts.add(product['name']);
      }
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> productCVS(String name) async {
    try {
      var response = await http.get(
          Uri.parse("$serverUrl/search/quantity?Name=$name"),
          headers: {'Content-Type': 'application/json'});
      markers = [];
      for (var cvs in jsonDecode(utf8.decode(response.bodyBytes)) as List) {
        Marker newMarker = Marker(
          markerId: MarkerId(cvs['storeId']),
          position: LatLng(cvs['loc_y'], cvs['loc_x']),
          onTap: () {
            selectStore(cvs['storeId']);
          },
          infoWindow: InfoWindow(
            title: cvs['storeId'],
            snippet: "남은수량 : ${cvs['quantity']}",
          ),
        );
        markers.add(newMarker);
      }
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> selectStore(String id) async {
    try {
      var response = await http.get(
          Uri.parse("$serverUrl/oneStore?storeId=$id"),
          headers: {'Content-Type': 'application/json'});
      var parsedData = jsonDecode(utf8.decode(response.bodyBytes));
      selectedStore.id = parsedData['storeId'];
      selectedStore.name = parsedData['name'];
      selectedStore.address = parsedData['address'];
      selectedStore.pNumber = parsedData['phoneNumber'] == "nan" ? null : parsedData['phoneNumber'];
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }
}
