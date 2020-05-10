import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:io';

class PainelPassageiro extends StatefulWidget {
  @override
  _PainelPassageiroState createState() => _PainelPassageiroState();
}

class _PainelPassageiroState extends State<PainelPassageiro> {

  List<String> itensMenu = [
    "Configurações", "Deslogar"
  ];
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera = CameraPosition(
            target: LatLng(-7.023786, -37.278468)
  );

  _deslogarUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");

  }

  _escolhaMenuItem( String escolha ){

    switch( escolha ){
      case "Deslogar" :
        _deslogarUsuario();
        break;
      case "Configurações" :

        break;
    }

  }
  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  _adicionarListenerLocalizacao(){

    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10
    );
    geolocator.getPositionStream(locationOptions).listen((Position position){
      _posicaoCamera = CameraPosition(
          zoom: 18,
          target: LatLng(position.latitude, position.longitude),
        );
        _movimentarCamera(_posicaoCamera);
    });

  }

  _recuperaUltimaLocalizacaoConhecida( ) async{

    Position position = await Geolocator()
      //recupera a ultima possição que o android guardou (getLastKnownPosition)
      .getLastKnownPosition(
        desiredAccuracy: LocationAccuracy.high
      );
    
    setState(() {
      if (position != null) {
        _posicaoCamera = CameraPosition(
          zoom: 18,
          target: LatLng(position.latitude, position.longitude),
        );
        _movimentarCamera(_posicaoCamera);
      }
    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {

    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition)
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //metodo com retorno mais rapido
    _recuperaUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel passageiro"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _posicaoCamera,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey
                    ),
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white
                  ),
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      icon: Container(
                        width: 5,
                        height: 25,
                        margin: EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.amberAccent,
                        ),
                      ),
                      hintText: "Meu Local",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15,top: 5)
                    ),
                  ),
                ),
              )
            ),
            Positioned(
              top: 55,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey
                    ),
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Container(
                        width: 5,
                        height: 25,
                        margin: EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.local_taxi,
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Meu Local",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15,top: 5)
                    ),
                  ),
                ),
              )
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: Platform.isIOS 
                ? EdgeInsets.fromLTRB(20, 10, 20, 25) 
                : EdgeInsets.all(10),
                child: RaisedButton(
                        child: Text(
                          "Entrar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Colors.amber,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        onPressed: (){
                              
                        }
                       ),
              )
            )
          ],
        )
      ),
    );
  }
}
