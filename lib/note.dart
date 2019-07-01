class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  int _status;

  Note(this._title, this._date, this._priority, this._status,
      [this._description]);
  Note.withId(this._id, this._title, this._date, this._priority, this._status,
      [this._description]);

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get id => _id;

  int get status => _status;

  set status(int value) {
    if (value >= 1 && value <= 2) {
      _status = value;
    }
  }

  set id(int value) {
    _id = value;
  }

  int get priority => _priority;

  set priority(int value) {
    if (value >= 1 && value <= 2) {
      _priority = value;
    }
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  // Used to save and Retrive from DataBase

  // Converts Note Object To Map Object
  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    if(id!=null){
      map['id']=_id;
    }
    map['title']=_title;
    map['description']=_description;
    map['priority']=_priority;
    map['status']=_status;
    map['date']=_date;
    return map;
  }

  Note.fromMapObject(Map<String,dynamic> map){
    this._id = map['id'];
    this._title=map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._status = map['status'];
    this._date = map['date'];

  }
  

}
