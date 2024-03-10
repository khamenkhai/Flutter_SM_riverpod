// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_project/sm/generated/locale_keys.g.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${tr(LocaleKeys.lblLanguage)}".capitalizeFirst.toString()),),
      body: Column(
        children: [
          ListTile(
            title: Text("${tr(LocaleKeys.lblEng)}"),
            trailing:IconButton(onPressed: (){
              context.locale = Locale("en","");
            }, icon: 
            Icon(context.locale == Locale('en', '') ? Icons.radio_button_checked : Icons.radio_button_off)
            )
          ),
          ListTile(
            title: Text("${tr(LocaleKeys.lblMM)}"),
            trailing:IconButton(onPressed: (){
              context.locale = Locale("my","");
            }, icon: 
            Icon(context.locale == Locale('my', '') ? Icons.radio_button_checked : Icons.radio_button_off)
            )
          ),
        ],
      ),
    );
  }
}
