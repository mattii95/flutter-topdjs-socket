class DjModel {
  String id;
  String name;
  int votes;

  DjModel({
    required this.id,
    required this.name,
    required this.votes,
  });

  factory DjModel.fromMap(Map<String, dynamic> obj) => DjModel(
        id: obj.containsKey('id') ? obj['id'] : 'no-id',
        name: obj.containsKey('name') ? obj['name'] : 'no-name',
        votes: obj.containsKey('votes') ? obj['votes'] : 0,
      );
}
