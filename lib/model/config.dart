class Config {
  int id;

  String newsFetchedStartUtc;

  String newsFetchedEndUtc;

  Config({this.id, this.newsFetchedStartUtc, this.newsFetchedEndUtc});

  factory Config.fromJson(Map<String, dynamic> json) {
    final config = Config();
    config.id = json['id'];
    config.newsFetchedStartUtc = json['newsFetchedStartUtc'];
    config.newsFetchedEndUtc = json['newsFetchedEndUtc'];

    return config;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'newsFetchedStartUtc': newsFetchedStartUtc,
      'newsFetchedEndUtc': newsFetchedEndUtc
    };
  }
}
