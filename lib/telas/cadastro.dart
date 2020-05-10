import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/model/usuario.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override

  TextEditingController _controllerNome = TextEditingController(text: "reinaldo");
  TextEditingController _controllerEmail = TextEditingController(text: "reinaldo@");
  TextEditingController _controllerSenha = TextEditingController(text: "123456");
  bool _tipoUsuario = false;
  String _mensagemErro = " ";

  _validarCampos(){
    //recuperando dados
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    //validando campos  
    if ( nome.isNotEmpty){

      if(email.contains("@") && email.isNotEmpty){

        if (senha.length > 5 && senha.isNotEmpty) {

          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;
          //recebendo o tipo de usuario 
          usuario.tipoUsuario = usuario.verificaTipoUsuario(_tipoUsuario);

          _cadastrarUsuario(usuario);

        }else{
          setState(() {
            _mensagemErro = "Digite uma senha de no mínimo 6 digitos.";
          });
        }
      }else{
        setState(() {
          _mensagemErro = "Preencha com um e-mail valido.";
        });
      }
    }else{
      setState(() {
        _mensagemErro = "Preencha um nome.";
      });
    }
  }

  _cadastrarUsuario(Usuario usuario) async {

    FirebaseAuth auth =  FirebaseAuth.instance;
    Firestore db = Firestore.instance;
    
    auth.createUserWithEmailAndPassword(
      email: usuario.email.trim(),
      password: usuario.senha.trim()
    ).then((firebaseUser){
      db.collection("usuarios")
      .document(firebaseUser.user.uid)
      .setData( usuario.toMap());
      
      //redirecionando o usuario para o seu painel expecifico
      switch (usuario.tipoUsuario) {
      case "motorista":
        //remove as rotas que vinheram antes.
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/painel-motorista",
          (_) => false
        );
        break;
      case "passageiro":
      //remove as rotas que vinheram antes.
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/painel-passageiro",
          (_) => false
        );
        break;
      default:
    }
 
    }).catchError((){
      _mensagemErro = "Erro ao autenticar";
    });
    //redirecionando o usuario para o seu painel expecifico
    
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("imagens/backgroundyellow.png"),
              //deixando a tela preenchida
              fit: BoxFit.cover
          )
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _controllerNome,
                  cursorColor: Colors.amberAccent,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome completo",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
                TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "e-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text("Passageiro"),
                      //caso seja falso será passageiro
                      //value define o valor inicial
                      Switch(
                        value: _tipoUsuario,
                         onChanged: (bool value){
                           setState(() {
                             _tipoUsuario = value;
                           });
                         }
                      ),

                      Text("Motorista")

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                        "Cadastrar-se",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                      color: Colors.amber,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: (){
                        _validarCampos();
                      }
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                        _mensagemErro,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}