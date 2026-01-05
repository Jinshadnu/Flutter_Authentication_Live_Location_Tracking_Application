import 'package:firebase_location_tracking/features/auth/domain/repositories/map/domain/services/presentation/controllers/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends GetView<MapController> {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: controller.animateToCurrentLocation,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => controller.signOut(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.currentPosition.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Unable to retrieve location. Please ensure location services are enabled and permissions are granted.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.checkLocationPermission(),
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: controller.cameraPosition.value,
            zoom: 15,
          ),
          onMapCreated: (GoogleMapController mapController) {
            controller.mapController.complete(mapController);
          },
          markers: controller.markers.value,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.animateToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
