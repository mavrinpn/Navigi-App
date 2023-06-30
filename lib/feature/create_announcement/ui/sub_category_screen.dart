import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/widgets/category/sub_category.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../bloc/sub_category/sub_category_cubit.dart';


class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({super.key});

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
      body: BlocBuilder<SubCategoryCubit, SubCategoryState>(
        builder: (context, state) {
          if (state is SubCategorySuccessState) {
            return ListView(
            children: state.subcategories
                .map((e) => SubCategoryWidget(name: e.name ?? '', id: e.id ?? ''))
                .toList(),
          );
          } else if (state is SubCategoryFailState) {
            return const Center(child: Text('проблемс'),);
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
