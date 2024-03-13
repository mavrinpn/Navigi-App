import 'package:flutter/cupertino.dart';
import 'package:smart/widgets/textField/elevated_text_field.dart';

class AppBarBottomSearchbar extends StatelessWidget
    implements PreferredSizeWidget {
  final Function(String value) onChange;
  const AppBarBottomSearchbar({
    super.key,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(44 + 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedTextField(
          action: TextInputAction.search,
          onSubmitted: (value) {},
          onChange: onChange,
          height: 44,
          width: double.infinity,
          hintText: 'Recherche a Alger',
          icon: "Assets/icons/only_search.svg",
          onTap: () {},
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44 + 12);
}
