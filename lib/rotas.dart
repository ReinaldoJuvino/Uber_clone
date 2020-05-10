import 'package:flutter/material.dart';
import 'package:uber_clone/telas/Home.dart';
import 'package:uber_clone/telas/cadastro.dart';
import 'package:uber_clone/telas/painelMotorista.dart';
import 'package:uber_clone/telas/painelPassageiro.dart';

class Rotas {

  static Route<dynamic> gerarRotas(RouteSettings settings ){
    //settings.name é a rota que é passada
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => Home()
        );
      case "/cadastro":
        return MaterialPageRoute(
          builder: (_) => Cadastro()
        );
      case "/painel-passageiro":
        return MaterialPageRoute(
          builder: (_) => PainelPassageiro()
        );
      case "/painel-motorista":
        return MaterialPageRoute(
          builder: (_) => PainelMotorista()
        );
      default:
        _erroRota();
    }

  }

  static Route<dynamic> _erroRota(){

    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(

          appBar: AppBar(
            title: Text("Tela não encontrada"),
          ),
          body: Center(

            child: Text("Tela não encontrada"),

          ),

        );
      }
    );

  }


}