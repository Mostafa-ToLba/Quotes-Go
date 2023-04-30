

  class QouteModel{
  String? iconImage;
  String? name;
  String? arabicName;
  String? deutchName ;
  String? FranceName ;
  String? EspaniaName ;

  String? bngla;
  String? hindi ;
  String? portogul ;
  String? russia;
  String? Chinese;
  QouteModel({this.iconImage,this.name,this.arabicName,this.Chinese,this.russia,this.portogul,this.hindi,
  this.bngla,this.EspaniaName,this.FranceName,this.deutchName});

  QouteModel.fromJson(Map<String,dynamic>json)
  {
    iconImage=json['iconImage'];
    name=json['name'];
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
      'iconImage':iconImage,
      'name':name,
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