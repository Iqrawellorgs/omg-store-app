class Validators {
  static bool validatePhoneNumber(String value) {
    List valueList = value.split(' ');

    value = value.replaceAll(' ', '');
    value = value.replaceAll('-', '');
    value = value.replaceAll('.', '');
    String pattern =
        r'(?:\+?\d{1,3}[\s-]?)?\(?[0-9]{3}\)?[\s-]?[\d]{3}[\s-]?[\d]{4}';

    RegExp regex = RegExp(pattern);
    List alphabets = [
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'zero'
    ];
    if (regex.hasMatch(value)) {
      return false;
    } else {
      for (var data in valueList) {
        if (alphabets.contains(data.toString().toLowerCase())) {
          return false;
        } else {
          return true;
        }
      }
    }
    return true;
  }
}
