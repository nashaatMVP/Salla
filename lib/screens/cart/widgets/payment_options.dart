import 'package:flutter/material.dart';
import 'package:smart_shop/shared/app/constants.dart';
import 'package:smart_shop/shared/app/custom_container.dart';
import 'package:smart_shop/shared/app/custom_text.dart';
import '../../../shared/theme/app_colors.dart';

class PaymentOptions extends StatefulWidget {
  const PaymentOptions({super.key});

  @override
  _PaymentOptionsState createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  String? _selectedPayment;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return CustomContainer(
      height: 500,
      child: ListView(
        children: [
          _buildPaymentOption("Cash on Delivery" , "cash", Icons.monetization_on),
          _buildDisabledOption("Debit/Credit Card" , Icons.credit_card_outlined , appColors),
          kGap10,
          kGap10,
          _buildDisabledOption("Apple Pay" , Icons.apple , appColors),
          kGap10,
          kGap10,
          const Divider(height: 4, color: Colors.grey, thickness: 7),
        ],
      ),
    );
  }
  Widget _buildPaymentOption(String title, String value, IconData icon) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return RadioListTile<String>(
      value: value,
      contentPadding: EdgeInsets.zero,
      groupValue: _selectedPayment,
      activeColor: Colors.green,
      onChanged: (val) => setState(() => _selectedPayment = val),
      title: Row(
        children: [
          TextWidgets.bodyText(title,fontSize: 13,color: appColors.primaryColor),
          const Spacer(),
          Icon(icon, size: 20, color: Colors.green),
          kGap30,
        ],
      ),
    );
  }
  Widget _buildDisabledOption(String title , icon , appColors) {
    return  Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: [
          const Icon(Icons.radio_button_off,size: 19 , color: Colors.grey),
          kGap25,
          TextWidgets.bodyText(title,fontSize: 13, color: Colors.grey,),
          const Spacer(),
          Icon(icon, size: 20 , color: Colors.grey,),
          kGap30,
        ],
      ),
    );
  }

}
