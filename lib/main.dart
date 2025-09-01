import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/auth/screen/login_screen.dart';
import 'package:travel_app/core/drawer_menu.dart';
import 'package:travel_app/home/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 6, 23, 174),
        ),
        scaffoldBackgroundColor: Colors.transparent,
        drawerTheme: const DrawerThemeData(scrimColor: Colors.black26),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
        ),
      ),

      debugShowCheckedModeBanner: false,
            builder: (context, child) {
        return Stack(
          children: [
            
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 216, 216, 216),
                    Color.fromARGB(255, 229, 229, 229), 
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            if (child != null) child,
          ],
        );
      },

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // login - home geçiş
          if (snapshot.data == null) {
            return const LoginScreen();
          } else {
            return const DrawerMenu();
          }
        },
      ),
    );
  }
}
