import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, required this.searchController, this.onSubmit, this.onChanged, this.onClose});
  final TextEditingController searchController;
  final Function(String?)? onSubmit;
  final Function(String?)? onChanged;
  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return SizedBox(
      height: 35,
      child: TextField(
        controller: searchController,
        style:  TextStyle(
          decorationThickness: 0,
          color: appColors.primaryColor,
        ),
        decoration: InputDecoration(
          hintText: "Search , PHONES , LAPTOPS",
          hintStyle:  TextStyle(
            color: appColors.primaryColor.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: appColors.searchColor,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: InkWell(
            onTap: onClose,
            child: Icon(
              Icons.cancel_outlined,
              size: 20,
              color: appColors.primaryColor,
            ),
          ),
          prefixIcon: Icon(
            CupertinoIcons.search,
            size: 19,
            color: appColors.primaryColor,
          ),
          contentPadding: const EdgeInsets.all(4),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmit,
      ),
    );
  }
}
