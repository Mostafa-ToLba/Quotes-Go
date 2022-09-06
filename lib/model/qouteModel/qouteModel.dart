

  class QouteModel{
  String? iconImage;
  String? name;
  QouteModel({this.iconImage,this.name});

  QouteModel.fromJson(Map<String,dynamic>json)
  {
    iconImage=json['iconImage'];
    name=json['name'];
  }

  Map<String,dynamic>toMap()
  {
    return {
      'iconImage':iconImage,
      'name':name,
    };
  }

}