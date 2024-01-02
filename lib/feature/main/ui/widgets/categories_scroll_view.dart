import 'package:flutter/material.dart.';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/category/category_cubit.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/widgets/category/category.dart';

class CategoriesScrollView extends StatelessWidget {
  const CategoriesScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategorySuccessState) {
          return SizedBox(
            width: double.infinity,
            height: 160,
            child: ListView(
              physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              scrollDirection: Axis.horizontal,
              children: state.categories
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: CategoryWidget(
                          category: e,
                          isActive: false,
                          width: 108,
                          height: 160,
                        ),
                      ))
                  .toList(),
            ),
          );
        } else if (state is CategoryFailState) {
          return const Center(
            child: Text('Проблемс'),
          );
        } else {
          return Center(
            child: AppAnimations.bouncingLine,
          );
        }
      },
    );
  }
}
