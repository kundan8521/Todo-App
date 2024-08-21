import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../views/screens/home_screen.dart';

class LocationController extends ChangeNotifier {
  String locationName = "Unknown Location";
  bool isLoading = false;
  Position? userLocation;
  bool? isConnected=false;

  Future<bool> checkInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<Position?> getCurrentUserLocation(BuildContext context) async {
    bool hasInternet = await checkInternetConnection();
    if (!hasInternet) {
      showSnackBar(context, 'Please connect to Wi-Fi or turn on your mobile data.');
      return null;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar(context, 'Location services are disabled. Please enable them.',);
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        showSnackBar(context, 'Location permission denied. Please grant permission to access your location.');
        return null;
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return '${place.subLocality}, ${place.locality}, ${place.country}';
      }
    } catch (e) {
      print("Error getting address: $e");
    }
    return 'Unknown Location';
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> sendLocation(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    userLocation = await getCurrentUserLocation(context);
    if (userLocation != null) {
      locationName = await getAddressFromLatLng(userLocation!);
      isLoading = false;
      notifyListeners();
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

    } else {
      isLoading = false;
      notifyListeners();
    }
  }
}
