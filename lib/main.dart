import 'package:e_commerce_/models/app_state.dart';
import 'package:e_commerce_/pages/login_page.dart';
import 'package:e_commerce_/pages/products_page.dart';
import 'package:e_commerce_/pages/register_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final user = prefs.getString('user');
  print("user=$user");
  final token = prefs.getString('token');
  print("token=$token");
  runApp(MyApp(
    token: token,
    user: user,
  ));
}

class MyApp extends StatelessWidget {
  final String user;
  final String token;
  MyApp({this.user, this.token});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => AppStateProvider(),
          ),
        ],
        child: Consumer<AppStateProvider>(
          builder: (context, appstateProvider, __) => MaterialApp(
            routes: {
              '/products': (BuildContext context) => ProductsPage(
                    onInit: () {},
                  ),
              '/login': (BuildContext context) => LoginPage(),
              '/register': (BuildContext context) => RegisterPage(),
            },
            debugShowCheckedModeBanner: false,
            title: 'E-Commerce',
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.blue[400],
              accentColor: Colors.deepPurple[300],
              textTheme: TextTheme(
                headline5: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
                headline6: TextStyle(
                  fontSize: 36,
                  fontStyle: FontStyle.italic,
                ),
                bodyText2: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home:
                (user == null && token == null) ? LoginPage() : ProductsPage(),
          ),
        ));
  }
}
