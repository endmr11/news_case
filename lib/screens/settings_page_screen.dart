import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:news_case/helpers/theme_color_data.dart';
import 'package:provider/provider.dart';

class SettingsPageScreen extends StatefulWidget {
  const SettingsPageScreen({Key? key}) : super(key: key);

  @override
  _SettingsPageScreenState createState() => _SettingsPageScreenState();
}

class _SettingsPageScreenState extends State<SettingsPageScreen> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeColorData>(context);
    var themeProviderNoListen =
        Provider.of<ThemeColorData>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const LocaleText("settings_page_screen_appbar_title"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildThemeDataColorSwitch(themeProvider, themeProviderNoListen),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LocaleText(
                  "settings_language_title",
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        LocaleNotifier.of(context)!.change('en');
                      },
                      child: const Text("English"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        LocaleNotifier.of(context)!.change('tr');
                      },
                      child: const Text("Türkçe"),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  SwitchListTile _buildThemeDataColorSwitch(
      ThemeColorData themeProvider, ThemeColorData themeProviderNoListen) {
    return SwitchListTile(
      title: themeProvider.isLight
          ? const LocaleText("settings_theme_data_ligt_text")
          : const LocaleText("settings_theme_data_dark_text"),
      onChanged: (_) {
        themeProviderNoListen.changeTheme();
      },
      value: themeProvider.isLight,
    );
  }
}
