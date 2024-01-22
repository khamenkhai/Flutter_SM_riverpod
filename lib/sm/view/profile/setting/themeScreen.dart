import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sm_project/sm/generated/locale_keys.g.dart';
import 'package:sm_project/sm/utils/theme.dart';

class ThemeScreen extends ConsumerStatefulWidget {
  const ThemeScreen({super.key});

  @override
  ConsumerState<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends ConsumerState<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${tr(LocaleKeys.lblTheme)}".capitalizeFirst.toString()),),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.sunny),
            title: Text("Light Theme"),
            trailing:IconButton(onPressed: (){
            ref.read(themeControllerProvider.notifier).toLightTheme();
            setState(() {
              
            });
            }, icon: 
            Icon(ref.watch(themeControllerProvider.notifier).thememode != ThemeMode.dark ? Icons.radio_button_checked : Icons.radio_button_off)
            )
          ),
          ListTile(
            leading: Icon(Icons.nights_stay),
            title: Text("Dark Theme"),
            trailing:IconButton(onPressed: (){
             ref.read(themeControllerProvider.notifier).toDarkTheme();
             setState(() {
               
             });
            }, icon: 
            Icon(ref.watch(themeControllerProvider.notifier).thememode == ThemeMode.dark ? Icons.radio_button_checked : Icons.radio_button_off)
            )
          ),
          // ListTile(
          //   title: Text("Myanmar"),
          //   trailing: Radio(
          //       value: false,
          //       groupValue: false,
          //       onChanged: (value) {
                  // context.locale = context.locale == Locale('en', '')
                  //     ? Locale('my', '')
                  //     : Locale('en', '');
          //       }),
          // ),
        ],
      ),
    );
  }
}
