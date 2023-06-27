import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';

class SearchProductsScreen extends StatefulWidget {
  const SearchProductsScreen({super.key});

  @override
  State<SearchProductsScreen> createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  final productsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
      body: Column(
        children: [
          const SizedBox(height: 16,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: width * 0.05),
            child: TextField(
              controller: productsController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.whiteGray)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.whiteGray)
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
