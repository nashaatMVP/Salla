// ignore_for_file: unnecessary_const
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/MODELS/product_model.dart';
import 'package:smart_shop/PROVIDERS/products_provider.dart';
import 'package:smart_shop/WIDGETS/category_widget.dart';
import 'package:smart_shop/WIDGETS/text_widget.dart';

import '../core/app_colors.dart';
import '../core/app_constans.dart';
import '../widgets/itemWidgets/search_widget.dart';

class SearchScreen extends StatefulWidget {
  static const routName = "/SearchScreen";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static List perviousSerches = [];
  TextEditingController searchController = TextEditingController();

  List<ProductModel> productListSearch = [];
  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    List<ProductModel> productList = passedCategory == null
        ? productsProvider.products
        : productsProvider.findByCategory(categoryName: passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // touch any place on scaffold and you will disapear the keyboard //
      },
      child: Scaffold(
        body: productList.isEmpty
            ? const Center(
                child: AppNameTextWidget(
                  text: "Unfortunately ,Not Found Products",
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              )
            : StreamBuilder<List<ProductModel>>(
                stream: productsProvider.fetchproductStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(
                        child: SizedBox(
          height: 150,
          width: 150,
          child: LottieBuilder.asset(
                    "IMG/Lottie/Loading.json",
                  ),
                    ),
                        
                        
                        );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        snapshot.error.toString(),
                      ),
                    );
                  } else if (snapshot.data == null) {
                    return const Center(
                      child: SelectableText(
                        "Not Found one",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 45,
                          child: TextField(
                            controller: searchController,
                            style: const TextStyle(
                              decorationThickness: 0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search",
                              contentPadding: const EdgeInsets.all(4),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // ignore: unnecessary_null_comparison
                              suffixIcon: searchController.text == null
                                  ? null
                                  : InkWell(
                                      onTap: () {
                                        searchController.clear();
                                      },
                                      child: const Icon(
                                        Icons.cancel,
                                        size: 20,
                                      ),
                                    ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              hintStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // onChanged: (pure) {
                            //   setState(() {});
                            // },
                            onEditingComplete: () {
                              perviousSerches.add(searchController.text);
                            },
                            onSubmitted: (value) {
                              setState(() {
                                //// Serach by Category
                                productListSearch =
                                    productsProvider.searchQuery(
                                  searchText: searchController.text,
                                );

                                //// Search by Title
                                productListSearch =
                                    productsProvider.searchTitle(
                                  searchText: searchController.text,
                                );
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        ////////////////////// End of Search TextField
                        //////////////////////////// Pervious Searech

                        SizedBox(
                          height: 35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: perviousSerches.length,
                            itemBuilder: (context, index) => previousSearchItem(
                              index: index,
                              productProvider: productsProvider,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        /////////////////////////////////// Search by Category
                        Visibility(
                          visible:
                              searchController.text.isNotEmpty ? false : true,
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: TitlesTextWidget(
                              label: "Suggestions",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        Visibility(
                          visible:
                              searchController.text.isNotEmpty ? false : true,
                          child: SizedBox(
                            height: 55,
                            width: double.infinity,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: AppConsts.categoryList.length,
                                itemBuilder: (context, index) {
                                  return CategorySearchWidget(
                                    name: AppConsts.categoryList[index].name,
                                  );
                                }),
                          ),
                        ),

                        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                        if (searchController.text.isNotEmpty &&
                            productListSearch.isEmpty) ...[
                          const Center(
                            child: TitlesTextWidget(
                              label: "Not Found.....",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                        Expanded(
                          child: DynamicHeightGridView(
                            physics: const BouncingScrollPhysics(),
                            itemCount: searchController.text.isNotEmpty
                                ? productListSearch.length
                                : productList.length,
                            crossAxisCount: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            builder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SearchWidget(
                                  productId: searchController.text.isNotEmpty
                                      ? productListSearch[index]
                                          .productID //////////// Start list in search
                                      : productList[index].productID,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }

  previousSearchItem(
      {required int index, required ProductProvider productProvider}) {
    return InkWell(
      onTap: () {},
      child: Dismissible(
        key: GlobalKey(),
        onDismissed: (DismissDirection dir) {
          perviousSerches.removeAt(index);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.goldenColor),
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 191, 167, 231)),
            child: Row(
              children: [
                const Icon(
                  IconlyLight.timeCircle,
                  size: 15,
                  color: AppColors.goldenColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                TitlesTextWidget(
                  label: perviousSerches[index],
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 253, 252, 255),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
