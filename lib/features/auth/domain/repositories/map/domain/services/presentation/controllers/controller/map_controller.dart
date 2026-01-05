import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();

  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final Rx<LatLng> cameraPosition = const LatLng(0, 0).obs;
  final markers = <Marker>{}.obs;
  final RxBool isLoading = true.obs;
  final RxString statusMessage = 'Getting your location...'.obs;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      statusMessage.value =
          'Location services are disabled. Please enable them.';
      isLoading.value = false;
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        statusMessage.value = 'Location permissions are denied';
        isLoading.value = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      statusMessage.value =
          'Location permissions are permanently denied. Please enable them in app settings.';
      isLoading.value = false;
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _getCurrentLocation();
      _startLocationUpdates();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      isLoading.value = true;
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition.value = position;
      _updateCameraPosition(position);
      _updateMarker(position);
      statusMessage.value = 'Location updated';
    } catch (e) {
      statusMessage.value = 'Error getting location: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _startLocationUpdates() {
    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        currentPosition.value = position;
        _updateCameraPosition(position);
        _updateMarker(position);
      },
      onError: (e) {
        statusMessage.value = 'Location error: $e';
      },
    );
  }

  void _updateCameraPosition(Position position) {
    cameraPosition.value = LatLng(position.latitude, position.longitude);
  }

  void _updateMarker(Position position) {
    final marker = Marker(
      markerId: const MarkerId('current_location'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: const InfoWindow(title: 'Your Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    markers.value = {marker};
  }

  Future<void> animateToCurrentLocation() async {
    if (currentPosition.value == null) return;

    final GoogleMapController controller = await mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentPosition.value!.latitude,
            currentPosition.value!.longitude,
          ),
          zoom: 15,
        ),
      ),
    );
  }

  Future<String?> getAddressFromLatLng(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.country}';
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }
}
