import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nhk_easy/error_reporter.dart';
import 'package:nhk_easy/repository/base_repository.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  final _baseRepository = BaseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Misc'),
            tiles: [
              SettingsTile(
                title: Text('Clear Cache'),
                leading: Icon(Icons.storage),
                onPressed: _clearCache,
              ),
              SettingsTile(
                title: Text('Privacy Policy'),
                leading: Icon(Icons.description),
                onPressed: _openPrivacyPolicy,
              )
            ],
          )
        ],
      ),
    );
  }

  void _clearCache(BuildContext context) {
    final yesButton = TextButton(
      child: Text(
        'Yes',
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        _baseRepository.dropDatabase().then((value) {
          Navigator.pop(context);

          Fluttertoast.showToast(
              msg: 'Cache removed', gravity: ToastGravity.CENTER);
        }).catchError((error, stackTrace) {
          Navigator.pop(context);

          Fluttertoast.showToast(
              msg: 'Failed to remove cache', gravity: ToastGravity.CENTER);

          ErrorReporter.reportError(error, stackTrace);
        });
      },
    );
    final noButton = TextButton(
      child: Text('No'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    final alertDialog = AlertDialog(
      content: Text(
          'Are you sure to clear cache? (This will remove all cached news.)'),
      actions: <Widget>[yesButton, noButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  void _openPrivacyPolicy(BuildContext context) async {
    final url = 'https://github.com/nhk-news-web-easy/nhk-easy-mobile-privacy-policy';
    final uri = Uri.https('github.com', '/nhk-news-web-easy/nhk-easy-mobile-privacy-policy');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final okButton = TextButton(
        child: Text('Ok'),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      final alertDialog = AlertDialog(
        content: Text(
            'Failed to open privacy policy in your default browser, you can view it at $url'),
        actions: <Widget>[okButton],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        },
      );
    }
  }
}
