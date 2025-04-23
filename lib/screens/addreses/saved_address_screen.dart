import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salla/screens/addreses/AddAddressScreen.dart';
import 'package:salla/screens/addreses/provider/address_provider.dart';
import 'package:salla/screens/addreses/widgets/add_new_address_card.dart';
import 'package:salla/shared/app/custom_appbar.dart';
import 'package:salla/shared/app/custom_button.dart';
import '../../shared/app/constants.dart';
import '../../shared/app/custom_container.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/theme/app_colors.dart';
import 'model/address_model.dart';

class SavedAddressScreen extends StatelessWidget {
  const SavedAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: CustomAppBar(onDelete: () {}, text: "Saved Addresses"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            kGap10,
            CustomContainer(
              height: addressProvider.getaddress.length * 80,
              child: ListView.builder(
                  itemCount: addressProvider.getaddress.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: addressProvider.getaddress.values.toList()[index],
                      child: const AddressWidget(),
                    );
                  },
              ),
            ),
            kGap10,
            addressProvider.getaddress.isEmpty
                ? const SizedBox.shrink()
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: CustomButton(
                  onPressed: () {
                    if(addressProvider.getSelectedAddress() != null){
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You Must Select Address')));
                    }
                  },
                  text: "Submit",
                  height: 50,
                  fontSize: 14,
                  borderRadius: 10,
                  textColor: appColors.secondaryColor,
                  backgroundColor: appColors.primaryColor,
              ),
            ),
            kGap10,
            AddNewAddressCard(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AddressEditScreen())),
            ),
            kGap70,
          ],
        ),
      ),
    );
  }
}


class AddressWidget extends StatefulWidget {
  const AddressWidget({Key? key}) : super(key: key);

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}
class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    final addressModel = Provider.of<AddressModel>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    final addressProvider = Provider.of<AddressProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 3),
      child: Card(
        elevation: 2,
        color: appColors.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                child: Radio<AddressModel>(
                  fillColor: MaterialStateColor.resolveWith((states) => appColors.primaryColor),
                  value: addressModel,
                  groupValue: addressProvider.getSelectedAddress(),
                  onChanged: (AddressModel? selectedAddress) => addressProvider.setSelectedAddress(selectedAddress!),
                ),
              ),
              kGap20,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidgets.bodyText(
                    '${addressModel.area}, ${addressModel.flat} ${addressModel.town}, ${addressModel.state}',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: appColors.primaryColor,
                  ),
                  kGap5,
                  Row(
                    children: [
                      TextWidgets.bodyText('+971 - ${addressModel.phoneNumber}',
                        color: appColors.primaryColor,
                        fontWeight: FontWeight.bold, fontSize: 12,
                      ),
                      kGap5,
                      const Icon(
                        Icons.verified,
                        size: 14,
                        color: greenColor,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressEditScreen(
                        flat: addressModel.flat,
                        state: addressModel.state,
                        town: addressModel.town,
                        area: addressModel.area,
                        phoneNumber: addressModel.phoneNumber,
                      ),
                    )),
                icon: const Icon(Icons.edit_outlined,color: blueColor,size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
