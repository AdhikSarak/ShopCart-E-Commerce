import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';
import 'package:shiv/views/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDnxIbOSNqiLLifEaupkQBduv7ssQDFB_E",
      appId: "1:545518802114:android:dcc55fbb0092dee4ead75b",
      messagingSenderId: "545518802114",
      projectId: "shiv-c2271",
      storageBucket: "shiv-c2271.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: darkFontGrey,
          ),
          backgroundColor: Colors.transparent,
        ),
        //fontFamily: regular,
      ),
      home: const SplashScreen(),
    );
  }
}
