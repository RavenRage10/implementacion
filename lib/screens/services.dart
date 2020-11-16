import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:implementacion/models/service_model.dart';

class Services extends StatefulWidget {
  static const routeName = '/services';
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List _cities = [
    "Cluj-Napoca",
    "Bucuresti",
    "Timisoara",
    "Brasov",
    "Constanta"
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;
  List<Standings> _standingsList = List<Standings>();
  List<Tables> _tableList = List<Tables>();

  Future<String> _loadProductAsset(String equipo) async {
    var url = 'http://api.football-data.org/v2/competitions/PL/standings';

    var response = await http.get(url,
        headers: {'X-Auth-Token': '2356d455c5194505a9446ec6c3a3ea88'});

    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }
/*
Product _parseJsonForCrossword(String jsonString) {
  Map JSON = json.decode(jsonString);
  List<Image> words = new List<Image>();
  for (var word in JSON['across']) {
    words.add(new Image(word['number'], word['word']));
  }
  return new Product(JSON['id'], JSON['name'], new Image(words));
}
*/

  Future<Soccer> loadProduct(String equipo) async {
    String jsonProduct = await _loadProductAsset(equipo);
    final jsonResponse = json.decode(jsonProduct);
    Soccer search = new Soccer.fromJson(jsonResponse);

    return search;
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[0].value;
    loadProduct("Arsenal").then((value) {
      setState(() {
        _standingsList.addAll(value.standings);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _search();
    return Scaffold(
        appBar: AppBar(
          title: Text('EQUIPOS DE FUTBOL'),
          backgroundColor: Colors.redAccent,
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Please choose your city: "),
                    new Container(
                      padding: new EdgeInsets.all(16.0),
                    ),
                    new DropdownButton(
                      value: _currentCity,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    ),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Equipo',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'PJ',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'G',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'E',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'P',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'GF',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'GE',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'PTS',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'GD',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: _standingsList[0]
                          .table // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(element.position.toString() +
                                        ". " +
                                        element.team
                                            .name)), //Extracting from Map element the value
                                    DataCell(Text(element.pj.toString())),
                                    DataCell(Text(element.w.toString())),
                                    DataCell(Text(element.d.toString())),
                                    DataCell(Text(element.l.toString())),
                                    DataCell(Text(element.goalsFor.toString())),
                                    DataCell(
                                        Text(element.goalsAgainst.toString())),
                                    DataCell(Text(element.points.toString())),
                                    DataCell(Text(element.gd.toString())),
                                  ],
                                )),
                          )
                          .toList(),
                    ),
                  ],
                ))));
  }

  _search() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        decoration:
            InputDecoration(hintText: 'INGRESA EL EQUIPO (ejemplo: ARSENAL)'),
        onSubmitted: (texto) {
          texto = texto.toLowerCase();
          loadProduct(texto.toString()).then((value) {
            setState(() {
              _standingsList.clear();
              _standingsList.addAll(value.standings);
              _tableList.clear();
              for (var standing in _standingsList) {
                _tableList.addAll(standing.table);
              }
            });
          });
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _cities) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
    });
  }
}
