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
  List _leagues = [
    "Premier League",
    "LaLiga",
    "Bundesliga",
    "Seria A",
    "Ligue 1"
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentLeague;
  List<Standings> _standingsList = List<Standings>();
  List<Tables> _table = List<Tables>();

  Future<String> _loadProductAsset(String equipo) async {
    var url = 'http://api.football-data.org/v2/competitions/$equipo/standings';

    var response = await http.get(url,
        headers: {'X-Auth-Token': '2356d455c5194505a9446ec6c3a3ea88'});

    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<Soccer> loadProduct(String equipo) async {
    String jsonProduct = await _loadProductAsset(equipo);
    final jsonResponse = json.decode(jsonProduct);
    Soccer search = new Soccer.fromJson(jsonResponse);

    return search;
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentLeague = _dropDownMenuItems[0].value;

    loadProduct("PL").then((value) {
      setState(() {
        _standingsList.addAll(value.standings);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    new Text("Selecciona la Liga que deseas conocer: "),
                    new Container(
                      padding: new EdgeInsets.all(16.0),
                    ),
                    new DropdownButton(
                      value: _currentLeague,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    ),
                    _tablaposi()
                  ],
                ))));
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String league in _leagues) {
      items.add(new DropdownMenuItem(value: league, child: new Text(league)));
    }
    return items;
  }

  void changedDropDownItem(String selectedLeague) {
    setState(() {
      _currentLeague = selectedLeague;
      String _sigla = "PD";
      if (_currentLeague.compareTo("Premier League") == 0) {
        _sigla = "PL";
      } else if (_currentLeague.compareTo("LaLiga") == 0) {
        _sigla = "PD";
      } else if (_currentLeague.compareTo("Bundesliga") == 0) {
        _sigla = "BL1";
      } else if (_currentLeague.compareTo("Seria A") == 0) {
        _sigla = "SA";
      } else if (_currentLeague.compareTo("Ligue 1") == 0) {
        _sigla = "FL1";
      }

      loadProduct(_sigla).then((value) {
        setState(() {
          _standingsList.clear();
          _standingsList.addAll(value.standings);
        });
      });
    });
  }

  _tablaposi() {
    if (_standingsList.isEmpty) {
      return new CircularProgressIndicator();
    } else {
      return new DataTable(
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
                      DataCell(Text(element.goalsAgainst.toString())),
                      DataCell(Text(element.points.toString())),
                      DataCell(Text(element.gd.toString())),
                    ],
                  )),
            )
            .toList(),
      );
    }
  }
}
