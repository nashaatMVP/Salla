import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, required this.searchController, this.onSubmit, this.onChanged, this.onClose});
  final Function()? onClose;
  final Function(String?)? onSubmit;
  final Function(String?)? onChanged;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return SizedBox(
      height: 37,
      child: TextField(
        controller: searchController,
        style:  TextStyle(
          decorationThickness: 0,
          color: appColors.primaryColor,
          fontSize: 14
        ),
        onChanged: onChanged,
        onSubmitted: onSubmit,
        decoration: InputDecoration(
          hintText: "search  phones ,  laptops ,  etc",
          hintStyle:  TextStyle(
            color: appColors.primaryColor.withOpacity(0.4),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          contentPadding: const EdgeInsets.only(top: 2),
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
            size: 16,
            color: appColors.primaryColor.withOpacity(0.4),
          ),
          filled: true,
          fillColor: appColors.searchColor,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.primaryColor.withOpacity(0.4),width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300,width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.primaryColor.withOpacity(0.4),width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
