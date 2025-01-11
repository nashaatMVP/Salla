import 'package:flutter/material.dart';

class AddressModel with ChangeNotifier {
  final String phoneNumber;
  final String addressId;
  final String flat;
  final String area;
  // final String pin;
  final String state;
  // final String land;
  final String town;
    bool isSelected = false;

  AddressModel(
      {required this.phoneNumber,
      required this.addressId,
      required this.flat,
      required this.area,
      required this.state,
      // required this.land,
      // required this.pin,
      required this.town
      });
        String convertToString() {
    return 'Flat: $flat, Area: $area, State: $state,town: $town, Phone Number: $phoneNumber';
  }
}
