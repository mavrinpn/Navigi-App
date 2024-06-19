import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart/main.dart';
import 'package:smart/models/models.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/checkBox/custom_check_box.dart';

class CategoryRowWidget extends StatefulWidget {
  const CategoryRowWidget({
    super.key,
    required this.category,
    required this.currentSubcategoryId,
    required this.onSubcategoryChanged,
  });

  final Category category;
  final String? currentSubcategoryId;
  final Function(Subcategory subcategory) onSubcategoryChanged;

  @override
  State<CategoryRowWidget> createState() => _CategoryRowWidgetState();
}

class _CategoryRowWidgetState extends State<CategoryRowWidget> {
  bool opened = false;

  @override
  void initState() {
    super.initState();
    opened = widget.category.subcategories.where((item) => item.id == widget.currentSubcategoryId).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              opened = !opened;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 64,
                  child: widget.category.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: widget.category.imageUrl!,
                          fadeInDuration: Duration.zero,
                          errorWidget: (context, error, stackTrace) {
                            return Container();
                          },
                        )
                      : Container(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.category.getLocalizedName(currentLocaleShortName.value),
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.font16black,
                  ),
                ),
                RotatedBox(
                  quarterTurns: opened ? 1 : 0,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                )
              ],
            ),
          ),
        ),
        if (opened) ...[
          Column(
            children: [
              ...List.generate(
                widget.category.subcategories.length,
                (index) {
                  final subcategory = widget.category.subcategories[index];
                  final isSelected = subcategory.id == widget.currentSubcategoryId;

                  return InkWell(
                    onTap: () => widget.onSubcategoryChanged(subcategory),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 16),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        CustomCheckBox(
                          isActive: isSelected,
                          onChanged: () => widget.onSubcategoryChanged(subcategory),
                        ),
                        Expanded(
                          child: Text(
                            subcategory.localizedName(currentLocaleShortName.value),
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.font16black.copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ]),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ],
      ],
    );
  }
}
