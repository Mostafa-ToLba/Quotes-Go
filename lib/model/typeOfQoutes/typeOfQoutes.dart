

class TypeOfQoutesModel{

  String? Qoute;
  String? arabicQuote;

  TypeOfQoutesModel({this.Qoute,this.arabicQuote});

  TypeOfQoutesModel.fromJson(Map<String,dynamic>json)
  {
    Qoute=json['Qoute'];
    arabicQuote=json['arabicQuote'];
  }

  Map<String,dynamic>toMap()
  {
    return {
      'Qoute':Qoute,
      'arabicQuote':arabicQuote,
    };
  }

}
