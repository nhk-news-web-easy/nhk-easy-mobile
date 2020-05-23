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
            title: 'Misc',
            tiles: [
              SettingsTile(
                title: 'Clear Cache',
                leading: Icon(Icons.storage),
                onTap: () {
                  _clearCache(context);
                },
              ),
              SettingsTile(
                title: 'Privacy Policy',
                leading: Icon(Icons.description),
                onTap: () {
                  _openPrivacyPolicy(context);
                },
              )
            ],
          )
        ],
      ),
    );
  }

  void _clearCache(BuildContext context) {
    final yesButton = FlatButton(
      child: Text('Yes'),
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
    final noButton = FlatButton(
      child: Text('No'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    final alertDialog = AlertDialog(
      content: Text('Are you sure to remove cache?'),
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
    final url = 'https://github.com/Frederick-S/nhk-easy-mobile-privacy-policy';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final okButton = FlatButton(
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
