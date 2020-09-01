class Note{
  int _id;
  String _title;
  String _description;
  String _date;
  
  Note(this._title, this._date, [this._description]);

  Note.withId(this._id, this._title, this._date, [this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;

   set title(String newTitle){
     if(newTitle.isNotEmpty && newTitle.length <= 255)
      this._title = newTitle;
   }  
   
   set description(String newDesc){
     if(newDesc.isNotEmpty)
      this._description = newDesc;
   }

   set date(String newDate){
     if(newDate.isNotEmpty)
      this._date = newDate;
   }

    Map<String, dynamic> toMap(){
      var map = Map<String, dynamic>();
      if(_id != null){
        map['id'] = _id;
      }

      map['title'] = _title;
      map['description'] = _description;
      map['date'] = _date;

      return map;
    }


    Note.fromMapObject(Map<String, dynamic> map){
      this._id = map['id'];

      this._title = map['title'];
      this._description = map['description'];
      this._date = map['date'];
    }

}