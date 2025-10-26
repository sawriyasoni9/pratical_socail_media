
extension StringExtension on String {

  bool get hasOtherType {
    return this == 'Other';
  }

  int get toInt {
    return int.parse(this);
  }

  bool get hasValidEmail {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(trim());
  }

  bool get isBlank {
    return trim().isEmpty;
  }

}