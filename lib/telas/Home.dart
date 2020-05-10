import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerEmail = TextEditingController(text: "reinaldojuvino@gmail.com");
  TextEditingController _controllerSenha = TextEditingController(text: "123456");
  String _mensagemErro = " ";
  bool _carregando = false;
  _validarCampos(){ 
    //recuperando dados
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    //validando campos
    if(email.contains("@") && email.isNotEmpty){

      if (senha.length > 5 && senha.isNotEmpty) {

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);

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
  }
  Future _logarUsuario(Usuario usuario) async{

    setState(() {
      _carregando = true;
    });

    FirebaseAuth auth = FirebaseAuth.instance;
    
    await auth.signInWithEmailAndPassword(
      email: usuario.email,
      password: usuario.senha
    ).then((firebaseUser){

      _redefinirPainelPorTipoUsuario(firebaseUser.user.uid);

    }).catchError((){
      _mensagemErro = "Erro ao autenticar";
    });
  }

  _redefinirPainelPorTipoUsuario(String idUsuario)async{

    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot = await db.collection("usuarios")
    .document(idUsuario).get();

    Map<String,dynamic> dados = snapshot.data;
    String tipoUsuario = dados["tipoUsuario"];

    setState(() {
      _carregando = false;
    });

    switch (tipoUsuario) {
      case "motorista":
        Navigator.pushReplacementNamed(context,"/painel-motorista");
        break;
      case "passageiro":
      Navigator.pushReplacementNamed(context,"/painel-passageiro");
        break;
      default:
    }

  }

  _verificaUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    //verificando se o usuario esta logado
    FirebaseUser usuarioLogado = await auth.currentUser();

    if(usuarioLogado != null){
      String idUsuario = usuarioLogado.uid;
      _redefinirPainelPorTipoUsuario(idUsuario);
    }

  }

  @override
  void initState() {
    super.initState();
    _verificaUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //definindo o fundo 
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
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                      "imagens/whale.png",
                    //definindo o tamanho da imagem
                    width: 200,
                    height: 150,
                  ),
                ),
                TextField(
                  controller: _controllerEmail,
                  cursorColor: Colors.amberAccent,
                  autofocus: true,
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
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                        "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                      color: Colors.amber,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: (){
                        _validarCampos();
                      }
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                        "Não tem conta? cadastre-se!",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: (){
                      Navigator.pushNamed(
                        context, 
                        "/cadastro"
                      );
                    },
                  ),
                ),
                SizedBox(height: 16,),
                _carregando ?
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),) : Container(),
                
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
