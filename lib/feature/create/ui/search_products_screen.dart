import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/category/products.dart';
import '../../../widgets/textField/outline_text_field.dart';

List<String> list  = ['asdf','asdf','asdf'];

class SearchProductsScreen extends StatefulWidget {
  const SearchProductsScreen({super.key});

  @override
  State<SearchProductsScreen> createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  final productsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData.fallback(),
          backgroundColor: AppColors.empty,
          elevation: 0,
          title: Text(
            'Ajouter une annonce',
            style: AppTypography.font20black,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              OutLineTextField(
                controller: productsController,
                height: 46,
                hintText: '',
                width: 1000,
                onChange: (value) {
                  print(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 26, 0, 13),
                child: Text('Requêtes populaires',style: AppTypography.font16black.copyWith(fontSize: 14),),
              ),
              Wrap(
                children: list.map((e) => Padding(
                  padding: const EdgeInsets.all(3),
                  child: ProductWidget(name: e,),
                )).toList(),
              )
            ],
          ),
        ));
  }
}
