import 'package:flutter/material.dart';
import 'package:smart/main.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/utils/fonts.dart';

class MinMaxParameterWidget extends StatefulWidget {
  const MinMaxParameterWidget({
    super.key,
    required this.parameter,
  });

  final MinMaxParameter parameter;

  @override
  State<MinMaxParameterWidget> createState() => _MinMaxParameterWidgetState();
}

class _MinMaxParameterWidgetState extends State<MinMaxParameterWidget> {
  final minController = TextEditingController();
  final maxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.parameter.min != null) {
      minController.text = widget.parameter.min.toString();
    } else {
      minController.text = '';
    }
    if (widget.parameter.max != null) {
      maxController.text = widget.parameter.max.toString();
    } else {
      maxController.text = '';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyApp.getLocale(context) == 'fr'
                ? widget.parameter.frName
                : widget.parameter.arName,
            style: AppTypography.font16black.copyWith(fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: minController,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  decoration: const InputDecoration(
                    hintText: 'min',
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: (v) {
                    widget.parameter.min = int.tryParse(v);
                  },
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: TextField(
                  controller: maxController,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  decoration: const InputDecoration(
                    hintText: 'max',
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: (v) {
                    widget.parameter.max = int.tryParse(v);
                  },
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
