import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'notificationservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA0OdJI7iS5CIz5Jm092APMbJZ5ynJc3Jk",
      appId: "1:812866415102:android:dd28753b41e32e5c6378af",
      messagingSenderId: "812866415102",
      projectId: "fir-2-2a164",
    ),
  );
  runApp(const MyApp());
  await NotificationService().registerPushNotificationHandler();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:LoginPage(),
    );
  }
}



class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
      await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      return user;
    } catch (error) {
      print("Error during Google sign-in: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login with Google"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            User? user = await _handleSignIn();
            if (user != null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsPage(user),
                  ));
            }
          },
          child: Text("Sign In with Google"),
        ),
      ),
    );
  }
}

class UserDetailsPage extends StatelessWidget {
  final User user;

  UserDetailsPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
        actions: [

        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome, ${user.displayName}"),
            Text("Email: ${user.email}"),
            Text("UID: ${user.uid}"),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
