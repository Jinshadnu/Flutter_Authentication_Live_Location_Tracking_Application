import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_location_tracking/features/auth/domain/repositories/map/domain/services/presentation/controllers/controller/map_controller.dart';
import 'package:firebase_location_tracking/features/auth/domain/repositories/map/domain/services/presentation/controllers/views/map_view.dart';
import 'package:firebase_location_tracking/features/auth/domain/repositories/presentation/controllers/views/login_view.dart';
import 'package:firebase_location_tracking/features/auth/domain/repositories/presentation/controllers/views/register_view.dart';
import 'package:firebase_location_tracking/features/auth/domain/repositories/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashView()),
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/register', page: () => RegisterView()),
        GetPage(
          name: '/map',
          page: () => MapView(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => MapController());
          }),
        ),
      ],
    );
  }
}
