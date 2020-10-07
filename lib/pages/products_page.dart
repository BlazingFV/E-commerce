import 'dart:convert';

import 'package:e_commerce_/models/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsPage extends StatefulWidget {
  final void Function() onInit;
  ProductsPage({this.onInit});

  @override
  ProductsPageState createState() => ProductsPageState();
}

class ProductsPageState extends State<ProductsPage> {
  var data;
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _getUser();
  }

  _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var storedUser = prefs.getString('user');
    final rData = json.decode(storedUser);
    // print('Products:  ${json.decode(storedUser)} ');
//   print('$rData sss');
// setState(() {
//   data = rData['username'];
//   print('$data sss');
// });
  }

  @override
  Widget build(BuildContext context) {
    var userData =
        Provider.of<AppStateProvider>(context, listen: true).getUser();
        print(userData);
    return FutureBuilder(
        future: userData,
        builder: (context, snapShot) {
          if (snapShot.hasData && snapShot.data != null) {
            return Scaffold(
              body: Center(child: Text(snapShot.data.toString())),
            );
          } else if (!snapShot.hasData) {
            return CupertinoActivityIndicator(
              animating: true,
            );
          }
          return Text('');
        });
  }
}
