class Config {
  int id = 0;

  String newsFetchedStartUtc = '';

  String newsFetchedEndUtc = '';

  Config(
      {required this.id,
      required this.newsFetchedStartUtc,
      required this.newsFetchedEndUtc});

  factory Config.fromJson(Map<String, dynamic> json) {
    final config =
        Config(id: 0, newsFetchedStartUtc: '', newsFetchedEndUtc: '');
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
