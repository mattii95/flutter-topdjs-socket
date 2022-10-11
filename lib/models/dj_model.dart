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
        id: obj['id'],
        name: obj['name'],
        votes: obj['votes'],
      );
}
