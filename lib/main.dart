import 'package:flutter/material.dart';
import 'package:uber_clone/rotas.dart';
import 'package:uber_clone/telas/home.dart';

final ThemeData temaPadrao = ThemeData(
    accentColor: Colors.amber,
    primaryColor: Colors.amber,
    focusColor: Colors.red
);

void main() => runApp(MaterialApp(
  title: "Uber",
  home: Home(),
  theme: temaPadrao,
  debugShowCheckedModeBanner: false,
  initialRoute: "/",
  onGenerateRoute: Rotas.gerarRotas,

));

