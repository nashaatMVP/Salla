// ignore_for_file: unnecessary_const
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/screens/search/widgets/search_text_field.dart';
import 'package:smart_shop/screens/home/widgets/category_widget.dart';
import 'package:smart_shop/screens/search/widgets/search_widget.dart';

import '../../core/app_constans.dart';
import '../../models/product_model.dart';
import '../../providers/products_provider.dart';
import '../../shared/app/constants.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/theme/app_colors.dart';
class SearchScreen extends StatefulWidget {
  static const routName = "/SearchScreen";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<ProductModel> productListSearch = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final productsProvider = Provider.of<ProductProvider>(context, listen: false);
    String? passedCategory = ModalRoute.of(context)!.settings.arguments as String?;
    List<ProductModel> productList = passedCategory == null
        ? productsProvider.products
        : productsProvider.findByCategory(categoryName: passedCategory);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: productList.isEmpty
            ? Center(
                child:
                    TextWidgets.bodyText1("Unfortunately ,Not Found Products"))
            : StreamBuilder<List<ProductModel>>(
                stream: productsProvider.fetchproductStream(),
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kGap50,
                      kGap30,
                      /// search bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SearchTextField(
                            searchController: searchController,
                            onClose: (){
                              searchController.clear();
                              setState(() {});
                            },
                            onSubmit: (value) {
                              setState(() {
                                /// Search by Title
                                productListSearch = productsProvider.searchTitle(searchText: searchController.text);
                              });
                            },
                            // onChanged: (v) {
                            //   setState(() {
                            //     productListSearch = productsProvider.searchQuery(searchText: searchController.text);
                            //     v = productListSearch as String?;
                            //   });
                            // },
                        ),
                      ),

                      if (searchController.text.isNotEmpty && productListSearch.isEmpty) ...[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: TextWidgets.bodyText1("Not Found",color: appColors.primaryColor,fontSize: 14),
                          ),
                        ),
                      ],

                      Expanded(
                        child: ListView.separated(
                            itemCount: searchController.text.isNotEmpty ? productListSearch.length : productList.length,
                            itemBuilder: (context, index) => SearchWidget(
                              productId: searchController.text.isNotEmpty ? productListSearch[index].productID : productList[index].productID,
                            ),
                            separatorBuilder: (context, index) => const Divider(thickness: 1,height: 30),
                        )
                      ),
                    ],
                  );
                }),
      ),
    );
  }
}
