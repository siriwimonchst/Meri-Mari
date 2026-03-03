// lib/models/address_model.dart

class AddressModel {
  final String id;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String country;
  final String zipCode;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.country,
    required this.zipCode,
    this.isDefault = false,
  });

  factory AddressModel.fromMap(String id, Map<String, dynamic> map) {
    return AddressModel(
      id: id,
      addressLine1: map['addressLine1'] as String? ?? '',
      addressLine2: map['addressLine2'] as String? ?? '',
      city: map['city'] as String? ?? '',
      country: map['country'] as String? ?? '',
      zipCode: map['zipCode'] as String? ?? '',
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'country': country,
      'zipCode': zipCode,
      'isDefault': isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? country,
    String? zipCode,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  /// One-line display string shown in the card
  String get summary {
    final parts = <String>[
      addressLine1,
      if (addressLine2.isNotEmpty) addressLine2,
      city,
      country,
      zipCode,
    ];
    return parts.join(', ');
  }
}
