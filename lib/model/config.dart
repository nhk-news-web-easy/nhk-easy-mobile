class Config {
  final int id;

  final String newsFetchedStartUtc;

  final String newsFetchedEndUtc;

  Config({this.id, this.newsFetchedStartUtc, this.newsFetchedEndUtc});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'newsFetchedStartUtc': newsFetchedStartUtc,
      'newsFetchedEndUtc': newsFetchedEndUtc
    };
  }
}
