

class photoModel{
  String? photo;
  String? name;
  String? arabicName ;

  String? deutchName ;
  String? FranceName ;
  String? EspaniaName ;

  String? bngla;
  String? hindi ;
  String? portogul ;
  String? russia;
  String? Chinese;

  var time ;
  photoModel({this.photo,this.name,this.time,this.arabicName,this.deutchName,this.EspaniaName,this.FranceName,
  this.bngla,this.hindi,this.portogul,this.russia,this.Chinese});

  photoModel.fromJson(Map<String,dynamic>json)
  {
    photo=json['photo'];
    name=json['name'];
    time=json['time'];
    arabicName=json['arabicName'];
    deutchName=json['deutchName'];
    FranceName=json['FranceName'];
    EspaniaName=json['EspaniaName'];

    bngla=json['bngla'];
    hindi=json['hindi'];
    portogul=json['portogul'];
    russia=json['russia'];
    Chinese=json['Chinese'];
  }

  Map<String,dynamic>toMap()
  {
    return {
      'photo':photo,
      'name':name,
      'time':time,
      'arabicName':arabicName,
      'deutchName':deutchName,
      'FranceName':FranceName,
      'EspaniaName':EspaniaName,

      'bngla':bngla,
      'hindi':hindi,
      'portogul':portogul,
      'russia':russia,
      'Chinese':Chinese,
    };
  }

}