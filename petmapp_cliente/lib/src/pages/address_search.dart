import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/pages/place_service_v1.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  final sessionToken;
  var nombreDireccion;
  PlaceApiProvider apiClient;

  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          tooltip: 'Limpiar',
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => _navegarCancelar(context));
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: query == "" ? null : apiClient.fetchSuggestions(query),
        builder: (context, snapshot) => query == ""
            ? Container(
                child: Text("Ingrese su ubicación"),
              )
            : snapshot.hasData
                ? ListView.builder(
                    itemBuilder: (context, i) => ListTile(
                      title: Text((snapshot.data[i] as Suggestion).description),
                      onTap: () {
                        close(context, snapshot.data[i]);
                        //print((snapshot.data[i] as Suggestion).geocode);
                        // nombreDireccion =
                        //     (snapshot.data[i] as Suggestion).description;
                      },
                    ),
                    itemCount: snapshot.data.length,
                  )
                : Container(
                    child: Center(child: CircularProgressIndicator()),
                  ));
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
