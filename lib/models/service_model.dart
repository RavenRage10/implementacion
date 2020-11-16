class Soccer {
  List<Standings> standings;

  Soccer({this.standings});

  factory Soccer.fromJson(Map<String, dynamic> parsedJson) {
    var standing = parsedJson['standings'] as List;
    print(standing.runtimeType);
    List<Standings> standingList =
        standing.map((i) => Standings.fromJson(i)).toList();

    return Soccer(standings: standingList);
  }
}

class Standings {
  List<Tables> table;

  Standings({this.table});

  factory Standings.fromJson(Map<String, dynamic> parsedJson) {
    var tables = parsedJson['table'] as List;
    print(tables.runtimeType);
    List<Tables> tableList = tables.map((i) => Tables.fromJson(i)).toList();
    return Standings(
      table: tableList,
    );
  }
}

class Tables {
  int position;
  Team team;

  int pj;
  int w;
  int l;
  int d;
  int points;
  int goalsFor;
  int goalsAgainst;
  int gd;

  Tables(
      {this.position,
      this.team,
      this.points,
      this.d,
      this.gd,
      this.goalsAgainst,
      this.goalsFor,
      this.pj,
      this.l,
      this.w});

  factory Tables.fromJson(Map<String, dynamic> parsedJson) {
    return Tables(
        position: parsedJson['position'],
        team: Team.fromJson(parsedJson['team']),
        pj: parsedJson['playedGames'],
        w: parsedJson['won'],
        l: parsedJson['lost'],
        d: parsedJson['draw'],
        points: parsedJson['points'],
        goalsAgainst: parsedJson['goalsAgainst'],
        goalsFor: parsedJson['goalsFor'],
        gd: parsedJson['playedGames']);
  }
}

class Team {
  String name;

  Team({this.name});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(name: json['name']);
  }
}
