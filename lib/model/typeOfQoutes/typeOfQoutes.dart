

class TypeOfQoutesModel{

  String? Qoute;

  TypeOfQoutesModel({this.Qoute});

  TypeOfQoutesModel.fromJson(Map<String,dynamic>json)
  {
    Qoute=json['Qoute'];
  }

  Map<String,dynamic>toMap()
  {
    return {
      'Qoute':Qoute,
    };
  }

}
