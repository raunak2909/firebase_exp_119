class NoteModel {
  String title;
  String desc;
  String createdAT;

  NoteModel({required this.title, required this.desc, required this.createdAT});

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
        title: map['title'],
        desc: map['desc'],
        createdAT: map['createdAt']);
  }

  Map<String, dynamic> toMap() => {
    "title" : title,
    "desc" : desc,
    "createdAt" : createdAT
  };

}
