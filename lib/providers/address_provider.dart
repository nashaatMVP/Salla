import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/address_model.dart';
import '../core/my_app_functions.dart';

class AddressProvider with ChangeNotifier {
  final Map<String, AddressModel> _address = {};

  Map<String, AddressModel> get getaddress {
    return _address;
  }

  String selectedaddresses = "";

  // ignore: non_constant_identifier_names
  String get SelectedAddresses => selectedaddresses;
  AddressModel? _selectedAddress;

  AddressModel? getSelectedAddress() => _selectedAddress;

  void setSelectedAddress(AddressModel address) {
    _selectedAddress = address;
    String formattedAddress =
        '${_selectedAddress!.area} , ${_selectedAddress!.flat} ${_selectedAddress!.town} , ${_selectedAddress!.state} , \n\nPhone Number : +971-${_selectedAddress!.phoneNumber}';
    print(formattedAddress);
    selectedaddresses = formattedAddress;
    notifyListeners();
  }

  final userstDb = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
  // Firebase
  Future<void> addToAddressFirebase({
    required String phoneNumber,
    required String flat,
    required String area,
    // required String pincode,
    required String town,
    required String state,
    // required String land,
    required BuildContext context,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      MyAppFunctions()
          .globalMassage(context: context, message: "Plese Login First");
      return;
    }
    final uid = user.uid;
    final addressId = const Uuid().v4();
    try {
      await userstDb.doc(uid).update({
        'Address': FieldValue.arrayUnion([
          {
            'phoneNumber': phoneNumber,
            'addressId': addressId,
            'flat': flat,
            'area': area,
            'town': town,
            'state': state,
          }
        ])
      });
      await fetchAddress();
      // ignore: use_build_context_synchronously
      MyAppFunctions()
          .globalMassage(context: context, message: "Address has been Added");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAddress() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _address.clear();
      return;
    }
    try {
      final userDoc = await userstDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("Address")) {
        return;
      }
      final leg = userDoc.get("Address").length;
      print(leg);
      for (int index = 0; index < leg; index++) {
        _address.putIfAbsent(
            userDoc.get("Address")[index]["addressId"],
            () => AddressModel(
                  phoneNumber: userDoc.get("Address")[index]["phoneNumber"],
                  addressId: userDoc.get("Address")[index]["addressId"],
                  flat: userDoc.get("Address")[index]["flat"],
                  area: userDoc.get("Address")[index]["area"],
                  state: userDoc.get("Address")[index]["state"],
                  town: userDoc.get("Address")[index]["town"],
                ));
      }
      print(_address);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  /////////////// remove from firsore ///////////////
  Future<void> removeAddressFirestor({
    required String phoneNumber,
    required String flat,
    required String town,
    required String addressId,
    required context,
  }) async {
    final User? user = _auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userCart': FieldValue.arrayRemove([
          {
            'phoneNumber': phoneNumber,
            'flat': flat,
            'town': town,
          }
        ])
      });
      // await fetchCart();
      _address.remove(addressId);
      MyAppFunctions().globalMassage(
          context: context, message: "Item Removed Successfully");
    } catch (e) {
      rethrow;
    }
  }
}
