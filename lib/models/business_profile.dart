class BusinessProfile {
  final String shopName;
  final String address;
  final String state;
  final String gstin;
  final String phone;
  final String email;
  final String terms;

  const BusinessProfile({
    this.shopName = '',
    this.address = '',
    this.state = '',
    this.gstin = '',
    this.phone = '',
    this.email = '',
    this.terms = '1. Goods once sold will not be taken back.\n2. Subject to local jurisdiction.',
  });

  BusinessProfile copyWith({
    String? shopName,
    String? address,
    String? state,
    String? gstin,
    String? phone,
    String? email,
    String? terms,
  }) {
    return BusinessProfile(
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      state: state ?? this.state,
      gstin: gstin ?? this.gstin,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      terms: terms ?? this.terms,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopName': shopName,
      'address': address,
      'state': state,
      'gstin': gstin,
      'phone': phone,
      'email': email,
      'terms': terms,
    };
  }

  factory BusinessProfile.fromMap(Map<String, dynamic> map) {
    return BusinessProfile(
      shopName: map['shopName'] ?? '',
      address: map['address'] ?? '',
      state: map['state'] ?? '',
      gstin: map['gstin'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      terms: map['terms'] ?? '1. Goods once sold will not be taken back.\n2. Subject to local jurisdiction.',
    );
  }
}
