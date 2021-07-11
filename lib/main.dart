import 'package:dogbreadapp/services/api_imp.dart';
import 'package:dogbreadapp/views/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  runApp(MyApp());
}

List<SingleChildWidget> providers = [
  ...apis,
];

List<SingleChildWidget> apis = [
  // Provider<RESTApi>.value(value: RestImpl()),
  Provider<ApiImp>.value(value: ApiImp()),
];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dog Breed Search',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: DashboardView(),
        );
      },
    );
  }
}
