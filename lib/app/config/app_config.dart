class AppConfig {
  String? appName;
  bool debugShowCheckedModeBanner = false;

  AppConfig setAppName(String name) {
    appName = name;
    return this;
  }

  AppConfig setDebugShowCheckedModeBanner(bool show) {
    debugShowCheckedModeBanner = show;
    return this;
  }
}
