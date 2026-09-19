class Validators {
  // Required field validator
  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Mobile number validator (10 digits Indian format)
  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final clean = value.trim().replaceAll(RegExp(r'[\s\-+()]'), '');
    // Allow 10 digits or 12 digits with 91 prefix
    final tenDigit = clean.length == 12 && clean.startsWith('91')
        ? clean.substring(2)
        : clean;

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(tenDigit)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  // Email validator (optional or format check)
  static String? email(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      if (required) return 'Email is required';
      return null;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // GSTIN validator (15 alphanumeric characters)
  // Format: 2-digit state code + 10-char PAN + 1-char entity number + 'Z' + 1 checksum char
  static String? gstin(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      if (required) return 'GSTIN is required';
      return null;
    }
    final clean = value.trim().toUpperCase();
    final gstinRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    );
    if (!gstinRegex.hasMatch(clean)) {
      return 'Enter a valid 15-digit GSTIN (e.g. 27AABCR1234F1Z5)';
    }
    return null;
  }

  // Positive price / rate validator
  static String? positiveNumber(String? value, String fieldName, {bool allowZero = false}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final num? val = num.tryParse(value.trim());
    if (val == null) {
      return 'Enter a valid number';
    }
    if (allowZero ? val < 0 : val <= 0) {
      return '$fieldName must be ${allowZero ? 'greater than or equal to 0' : 'greater than 0'}';
    }
    return null;
  }

  // Positive integer quantity
  static String? quantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    final int? qty = int.tryParse(value.trim());
    if (qty == null || qty <= 0) {
      return 'Quantity must be at least 1';
    }
    return null;
  }

  // HSN/SAC code validator (optional, 2 to 8 digits)
  static String? hsnCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // optional
    }
    if (!RegExp(r'^\d{2,8}$').hasMatch(value.trim())) {
      return 'HSN/SAC should be 2 to 8 digits';
    }
    return null;
  }
}
