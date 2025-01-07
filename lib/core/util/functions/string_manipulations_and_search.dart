import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../main.dart';


final _context = navigatorKey.currentContext!;



class StringWithType<T> {
  const StringWithType(this.string, this.type);

  final String string;
  final T type;

  @override
  String toString() {
    return "\n$type \n$string\n";
  }
}

String wellFormatedString(String str, {String seperatorBetweenWords = " "}) {
  return str.trim().isEmpty
      ? str
      : str
          .trim()
          .split(RegExp(r' +'))
          .map(
            (word) =>
                word.substring(0, 1).toUpperCase() +
                word.substring(1).toLowerCase(),
          )
          .join(seperatorBetweenWords);
}

String firstName(String fullName) => fullName.split(RegExp(r' +')).first;

bool appCurrentDirectionalityIsRtl() =>
    Directionality.of(_context) == TextDirection.rtl;

bool firstCharIsRtl(String text) {
  if (text.trim().isEmpty) {
    return appCurrentDirectionalityIsRtl();
  }

  return intl.Bidi.startsWithRtl(text.trim());
}

TextDirection getDirectionalityOf(String text) =>
    firstCharIsRtl(text) ? TextDirection.rtl : TextDirection.ltr;

TextDirection getDirectionalityOfLangCode(String langCode) {
  return intl.Bidi.isRtlLanguage(langCode)
      ? TextDirection.rtl
      : TextDirection.ltr;
}


String multiLineConvertTolowerCamelCaseStyle(String multiLinestring) {
  return multiLinestring.split("\n").map((lineString) {
    return converTolowerCamelCaseStyle(lineString);
  }).join("\n");
}

String converTolowerCamelCaseStyle(String string) {
  final dartNamingMather = RegExp(r"^[a-zA-Z]\w*$");
  final whiteSpaceMatcher = RegExp(r" +");

  final stringList = string.characters.toList()
    ..removeWhere((char) =>
        !dartNamingMather.hasMatch(char) && !whiteSpaceMatcher.hasMatch(char));

  return wellFormatedString(stringList.join(), seperatorBetweenWords: "")
      .replaceRange(
    0,
    stringList.join().trim().isEmpty ? 0 : 1,
    stringList.join().trim().isEmpty
        ? ""
        : stringList.join().trim().substring(0, 1).toLowerCase(),
  );
}

extension on String {
  Set<String> toSet() => {for (int i = 0; i < length; i++) substring(i, i + 1)};

  List<String> toList() =>
      [for (int i = 0; i < length; i++) substring(i, i + 1)];
}
