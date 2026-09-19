class Party {
  final String id;
  final String name;
  final String mobile;
  final String address;
  final String state;
  final String? gstin;
  final String? email;
  final DateTime createdAt;

  Party({
    required this.id,
    required this.name,
    required this.mobile,
    required this.address,
    required this.state,
    this.gstin,
    this.email,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Party copyWith({
    String? id,
    String? name,
    String? mobile,
    String? address,
    String? state,
    String? gstin,
    String? email,
    DateTime? createdAt,
  }) {
    return Party(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      state: state ?? this.state,
      gstin: gstin ?? this.gstin,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'address': address,
      'state': state,
      'gstin': gstin,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Party.fromMap(Map<String, dynamic> map) {
    return Party(
      id: map['id'] as String,
      name: map['name'] as String,
      mobile: map['mobile'] as String,
      address: map['address'] as String,
      state: map['state'] as String,
      gstin: map['gstin'] as String?,
      email: map['email'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase() : 'P';
  }
}
