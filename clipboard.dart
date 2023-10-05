import 'package:flutter/services.dart';

class Clipbord {
  Clipbord._();

  Future<void> copiar(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
  }

  static Future<String> colar() async {
    final ClipboardData = await Clipbord.getDate(Clipboard.kTextPlain);
    return ClipboardData?.text ?? '';
  }

  Future<bool> hasData() async {
    return Clipboard.hasStrings();
  }

  static getDate(String kTextPlain) {}
}
//ORIGEM