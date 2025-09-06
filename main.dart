import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:flutter_project/splash%20screen/splash_screen.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras(); // Get available cameras
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required List<CameraDescription> cameras});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

       primarySwatch: Colors.blue
      ),
      home:
      SplashScreen(),
    );
  }
}




