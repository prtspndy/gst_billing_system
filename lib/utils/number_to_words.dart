/// Utility to convert monetary figures to Indian English words.
/// Example: 30558.46 -> "Thirty Thousand Five Hundred Fifty-Eight Rupees and Forty-Six Paise Only"
class NumberToWords {
  static const List<String> _units = [
    '',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen'
  ];

  static const List<String> _tens = [
    '',
    '',
    'Twenty',
    'Thirty',
    'Forty',
    'Fifty',
    'Sixty',
    'Seventy',
    'Eighty',
    'Ninety'
  ];

  static String convert(double amount) {
    if (amount <= 0) return 'Zero Rupees Only';

    final int rupees = amount.floor();
    final int paise = ((amount - rupees) * 100).round();

    final String rupeeWords = _convertNumber(rupees);
    final String paiseWords = paise > 0 ? _convertNumber(paise) : '';

    if (paise > 0) {
      if (rupees == 0) {
        return '$paiseWords Paise Only';
      }
      return '$rupeeWords Rupees and $paiseWords Paise Only';
    } else {
      return '$rupeeWords Rupees Only';
    }
  }

  static String _convertNumber(int n) {
    if (n == 0) return '';
    if (n < 20) return _units[n];
    if (n < 100) {
      final rem = n % 10;
      return _tens[n ~/ 10] + (rem > 0 ? '-${_units[rem]}' : '');
    }
    if (n < 1000) {
      final rem = n % 100;
      return '${_units[n ~/ 100]} Hundred${rem > 0 ? ' ${_convertNumber(rem)}' : ''}';
    }
    if (n < 100000) {
      final rem = n % 1000;
      return '${_convertNumber(n ~/ 1000)} Thousand${rem > 0 ? ' ${_convertNumber(rem)}' : ''}';
    }
    if (n < 10000000) {
      final rem = n % 100000;
      return '${_convertNumber(n ~/ 100000)} Lakh${rem > 0 ? ' ${_convertNumber(rem)}' : ''}';
    }
    final rem = n % 10000000;
    return '${_convertNumber(n ~/ 10000000)} Crore${rem > 0 ? ' ${_convertNumber(rem)}' : ''}';
  }
}
