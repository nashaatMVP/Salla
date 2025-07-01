import 'package:salla/MODELS/category_models.dart';
import '../shared/app/photo_link.dart';

class AppConsts {

  static List bannerImages = [
    PhotoLink.banner,
    PhotoLink.banner2,
    PhotoLink.banner3,
    PhotoLink.banner4,
  ];

  static List brandSvgs = [
    PhotoLink.adidasLink,
    PhotoLink.amazonLink,
    PhotoLink.androidLink,
    PhotoLink.benchLink,
    PhotoLink.gucciLink,
    PhotoLink.kangolLink,
    PhotoLink.nikesLink,
    PhotoLink.newBalanceLink,
    PhotoLink.samsungLink,
    PhotoLink.diorLink,
    PhotoLink.chanelLink,
  ];

  static List<CategoryModel> categoryList = [
    CategoryModel(
      id: "1",
      image: "assets/categories/visualhunter-1fbe8131b5.png",
      name: "Phones",
    ),
    CategoryModel(
      id: "1",
      image: "assets/categories/HeadPhones.png",
      name: "HeadPhones",
    ),
    CategoryModel(
      id: "1",
      image: "assets/categories/AirPods.png",
      name: "Air Pods",
    ),
    CategoryModel(
      id: "1",
      image: "assets/categories/smartWatch.png",
      name: "Watches",
    ),
    CategoryModel(
      id: "1",
      image: "assets/categories/Elctronics.png",
      name: "Accessories",
    ),
    CategoryModel(
      id: "1",
      image: "assets/categories/Camera.png",
      name: "Cameras",
    ),
    CategoryModel(
      id: "1",
      image: "assets/images/category/controller.jpg",
      name: "Gaming",
    ),
    CategoryModel(
      id: "1",
      image: "assets/categories/Laptpos.png",
      name: "Laptops",
    ),
    CategoryModel(
      id: "1",
      image: "assets/categories/Tools.png",
      name: "Tools",
    ),
    CategoryModel(
      id: "1",
      image: "assets/categories/Drones.png",
      name: "Drones",
    ),
    CategoryModel(
      id: "1",
      image: "assets/categories/sport.png",
      name: "Sports",
    ),
    CategoryModel(
      id: "1",
      image: "assets/categories/Kitchen.png",
      name: "Kitchen",
    ),
    CategoryModel(
      id: "1",
      image: "assets/categories/Furniture.png",
      name: "Furniture",
    ),
  ];
}
