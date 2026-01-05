import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_location_tracking/core/constants/app_constants.dart';

class SplashController extends GetxController {
  final GetStorage _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final isLoggedIn = _box.read(AppConstants.isLoggedIn) ?? false;
    if (isLoggedIn) {
      Get.offAllNamed('/map');
    } else {
      Get.offAllNamed('/login');
    }
  }
}