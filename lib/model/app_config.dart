class AppConfig {
  String sentryDsn = '';

  AppConfig();

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    final appConfig = AppConfig();
    appConfig.sentryDsn = json['sentryDsn'];

    return appConfig;
  }

  Map<String, dynamic> toMap() {
    return {'sentryDsn': sentryDsn};
  }
}
