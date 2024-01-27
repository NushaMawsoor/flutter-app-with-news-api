import 'views/homepage.dart';
import 'package:flutter/material.dart';

void main() =>
  runApp(MaterialApp(

    initialRoute: '/',
    routes: {

      '/': (context) => HomePage(),

    },

  ));


