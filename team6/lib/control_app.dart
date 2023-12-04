import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:team6/basic_information.dart';
import 'package:team6/class/models.dart';

final viewmodel = ChangeNotifierProvider<ViewModel>((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  final serverUrl = 'http://172.30.1.25:8080';
  Client me = Client();
  Owner me2 = Owner();
  String state = "client";
  LatLng myLocation = const LatLng(35.8862, 128.6101);
  List<Event> events = <Event>[];
  List<Marker> markers = <Marker>[];
  List<CVS> stores = <CVS>[];
  List<String> possibleProducts = <String>[];
  CVS selectedStore = CVS();
  List<Event> presentEvent = <Event>[];
  List<Favorite> myFavorites = <Favorite>[];
  List<CVS> myCVS = <CVS>[];
  List<Porder> myOrder = <Porder>[];
  String selectedCondition = "order";
  bool storeLoading = true;

  void seletedConditionChange(String condition) {
    selectedCondition = condition;
    notifyListeners();
  }

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
        this.state = state;
        if (response.body == "password incorrect") {
          return 0;
        } else if (response.body == "id incorrect") {
          return -1;
        } else {
          if (this.state == 'client') {
            me.cId = response.body;
          } else {
            me2.oId = response.body;
          }
          return 1;
        }
      } else {
        return -2;
      }
    } catch (e) {
      return -3;
    }
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
          onTap: () {
            selectStore(newStore.id!);
          },
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
        newEvent.imageUrl = event['image_Url'];
        events.add(newEvent);
      }
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
      selectedStore.pNumber =
          parsedData['phoneNumber'] == "nan" ? null : parsedData['phoneNumber'];
      if (parsedData['name'][0] == 'G') {
        selectedStore.imageUrl = 'assets/GS.png';
      } else if (parsedData['name'][0] == 'E') {
        selectedStore.imageUrl = 'assets/E24.png';
      } else if (parsedData['name'][0] == 'C') {
        selectedStore.imageUrl = 'assets/CU.png';
      } else if (parsedData['name'][0] == '7') {
        selectedStore.imageUrl = 'assets/Seven.png';
      }
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> storeInformation(CVS store) async {
    try {
      selectedStore = store;
      storeLoading = true;
      selectedStore.products = [];
      for (String categoryName in category) {
        selectedStore.productForCategory[categoryName] = [];
      }
      notifyListeners();
      var response = await http.get(
          Uri.parse(
              "$serverUrl/store/allProduct?storeId=${store.id}&clientId=${me.cId}"),
          headers: {'Content-Type': 'application/json'});
      for (var oProduct
          in jsonDecode(utf8.decode(response.bodyBytes)) as List) {
        Product newProduct = Product();
        newProduct.getJson(oProduct);
        selectedStore.products.add(newProduct);
        selectedStore.productForCategory[newProduct.category!]!.add(newProduct);
      }
      storeLoading = false;
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> getEvent(String id) async {
    try {
      presentEvent = [];
      notifyListeners();
      var response = await http.get(
          Uri.parse("$serverUrl/product/event?productId=$id"),
          headers: {'Content-Type': 'application/json'});
      for (var event in jsonDecode(utf8.decode(response.bodyBytes)) as List) {
        Event newEvent = Event();
        newEvent.name = event['eventName'];
        newEvent.estart = event['start'];
        newEvent.eend = event['end'];
        newEvent.policy = event['policy'];
        newEvent.imageUrl = event['image_Url'];
        presentEvent.add(newEvent);
      }

      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> favoriteModyfy(String storeId, Product product) async {
    try {
      final Map<String, dynamic> data = {
        "clientId": me.cId,
        "storeId": storeId,
        "productId": product.id,
      };
      presentEvent = [];
      notifyListeners();
      var response = await http.post(Uri.parse("$serverUrl/favorite/Modify"),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (response.body == "success") {
        product.hasFavorite = !product.hasFavorite!;
        int pind = selectedStore.products.indexOf(product);
        int cind = selectedStore.productForCategory[product.category]!
            .indexOf(product);
        selectedStore.products[pind].hasFavorite = product.hasFavorite;
        selectedStore.productForCategory[product.category]![cind].hasFavorite =
            product.hasFavorite;
      }
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> getMyFavorites() async {
    try {
      myFavorites = [];
      notifyListeners();
      var response = await http.get(
          Uri.parse("$serverUrl/favorite?clientId=${me.cId}"),
          headers: {'Content-Type': 'application/json'});
      for (var favor in jsonDecode(utf8.decode(response.bodyBytes)) as List) {
        Favorite newFavorite = Favorite();
        newFavorite.cvsId = favor['storeId'];
        newFavorite.cvsName = favor['storeName'];
        newFavorite.pId = favor['productId'];
        newFavorite.pName = favor['productName'];
        newFavorite.pPrice = favor['price'];
        newFavorite.pCategory = favor['category'];
        newFavorite.quantity = favor['quantity'];
        newFavorite.imageUrl = favor['image_Url'];
        newFavorite.arrivalTime = favor['arrivalTime'];

        myFavorites.add(newFavorite);
      }
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> getMyCVS() async {
    try {
      myCVS = [];
      notifyListeners();
      var response = await http.get(
          Uri.parse("$serverUrl/myCVS?ownerId=${me2.oId}"),
          headers: {'Content-Type': 'application/json'});
      for (var mycvs in jsonDecode(utf8.decode(response.bodyBytes)) as List) {
        CVS newCVS = CVS();
        newCVS.locX = mycvs['loc_x'];
        newCVS.locY = mycvs['loc_y'];
        newCVS.address = mycvs['address'];
        newCVS.id = mycvs['storeId'];
        newCVS.pNumber = mycvs['phoneNumber'];
        newCVS.name = mycvs['name'];
        if (mycvs['name'][0] == 'G') {
        newCVS.imageUrl = 'assets/GS.png';
      } else if (mycvs['name'][0] == 'E') {
        newCVS.imageUrl = 'assets/E24.png';
      } else if (mycvs['name'][0] == 'C') {
        newCVS.imageUrl = 'assets/CU.png';
      } else if (mycvs['name'][0] == '7') {
        newCVS.imageUrl = 'assets/Seven.png';
      }
        newCVS.revenue = mycvs['revenue'];
        myCVS.add(newCVS);
      }
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> deleteMyCVS(String id) async {
    try {
      var response = await http.get(
          Uri.parse("$serverUrl/myCVS/delete?storeId=$id"),
          headers: {'Content-Type': 'application/json'});
      if (response.body == "success") {
        int index = 0;
        for (int i = 0; i < myCVS.length; i++) {
          if (myCVS[i].id == id) {
            index = i;
            break;
          }
        }
        myCVS.removeAt(index);
      }
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> addMyCVS(String storeId, String storeName, String address,
      String phoneNumber, double locX, double locY) async {
    try {
      final Map<String, dynamic> data = {
        "StoreId": storeId,
        "NAME": storeName,
        "Address": address,
        "PhoneNumber": phoneNumber,
        "OwnerId": me2.oId,
        "loc_x": locX,
        "loc_y": locY,
      };
      var response = await http.post(Uri.parse("$serverUrl/myCVS/add"),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (response.body == "success") {
        CVS newCVS = CVS();
        newCVS.locX = locX;
        newCVS.locY = locY;
        newCVS.address = address;
        newCVS.id = storeId;
        newCVS.pNumber = phoneNumber;
        newCVS.name = storeName;
        myCVS.add(newCVS);
      }
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> addOrder(int quantity, String arrivalTime, String arrivalState,
      Product product, String storeId) async {
    try {
      final Map<String, dynamic> data = {
        "product_quantity": quantity,
        "arrival_time": arrivalTime,
        "arrival_state": arrivalState,
        "ownerId": me2.oId,
        "productId": product.id,
        "storeId": storeId,
      };
      myOrder = [];
      notifyListeners();
      var response = await http.post(Uri.parse("$serverUrl/myCVS/order/add"),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (response.body == "success") {
        Porder newPorder = Porder();
        newPorder.arrival = arrivalTime;
        newPorder.arrivalState = arrivalState;
        newPorder.quantity = quantity;
        newPorder.pName = product.name;
        myOrder.add(newPorder);
      }
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> getMyOrder(CVS store) async {
    try {
      selectedStore = store;
      myOrder = [];
      notifyListeners();
      var response = await http.get(
          Uri.parse("$serverUrl/myCVS/order?storeId=${store.id}"),
          headers: {'Content-Type': 'application/json'});
      for (var porder in jsonDecode(utf8.decode(response.bodyBytes)) as List) {
        Porder newPorder = Porder();
        newPorder.arrival = porder['arrival_time'];
        newPorder.arrivalState = porder['arrival_state'];
        newPorder.quantity = porder['product_quantity'];
        newPorder.pName = porder['productName'];
        newPorder.imageUrl = porder['image_Url'];
        newPorder.pPrice = porder['productPrice'];
        newPorder.category = porder['category'];
        myOrder.add(newPorder);
      }

      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> topProducts(CVS store) async {
    try {
      selectedStore = store;
      selectedStore.products = [];
      notifyListeners();
      var response = await http.get(
          Uri.parse("$serverUrl/myCVS/topProduct?storeId=${store.id}"),
          headers: {'Content-Type': 'application/json'});
      for (var prod in jsonDecode(utf8.decode(response.bodyBytes)) as List) {
        Product newProduct = Product();
        newProduct.id = prod['productId'];
        newProduct.name = prod['name'];
        newProduct.category = prod['category'];
        newProduct.price = prod['price'];
        newProduct.imageUrl = prod['image_Url'];
        newProduct.quantity = prod['quantity'];
        selectedStore.products.add(newProduct);
      }
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<int> buy(int quantity, Product product, String storeId) async {
    try {
      final Map<String, dynamic> data = {
        "quantity": quantity,
        "productId": product.id,
        "storeId": storeId,
      };
      myOrder = [];
      notifyListeners();
      var response = await http.post(Uri.parse("$serverUrl/payment/buy"),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (response.body == "success") {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      return -1;
    }
  }
}
