import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/ui/widgets/select_parameter_bottom_sheet.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/price_type.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/parameters_selection/input_parameter_widget.dart';
import 'package:smart/widgets/parameters_selection/multiple_chekbox.dart';
import 'package:smart/widgets/parameters_selection/select_parameter_widget.dart';
import '../../../managers/creating_announcement_manager.dart';
import '../../../models/item/item.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/textField/under_line_text_field.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  final priceController = TextEditingController(text: '0');
  final _formKey = GlobalKey<FormState>();

  late final List<PriceType> _availableTypes;
  late PriceType _priceType;
  List<Parameter> _parametersList = [];
  final Map<String, bool> _parametersRequired = {'price': false};

  @override
  void initState() {
    super.initState();
    final repository = RepositoryProvider.of<CreatingAnnouncementManager>(context);
    _availableTypes = PriceTypeExtendion.availableTypesFor(repository.creatingData.subcategoryId ?? '');
    _priceType = _availableTypes.first;
    _parametersList = repository.getParametersList();

    for (var parameter in _parametersList) {
      if (parameter is SelectParameter) {
        _parametersRequired[parameter.key] = parameter.currentValue.key != emptyParameter;
      } else if (parameter is SingleSelectParameter) {
        _parametersRequired[parameter.key] = parameter.currentValue.key != emptyParameter;
      } else if (parameter is MultiSelectParameter) {
      } else if (parameter is InputParameter) {
        _parametersRequired[parameter.key] = parameter.currentValue != null && parameter.currentValue != '';
      } else if (parameter is TextParameter) {
        _parametersRequired[parameter.key] = parameter.currentValue != '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<CreatingAnnouncementManager>(context);

    final localizations = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData.fallback(),
          backgroundColor: AppColors.appBarColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            AppLocalizations.of(context)!.features,
            style: AppTypography.font20black,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      for (var param in _parametersList) {
                        if (param is SelectParameter) {
                          param.currentValue = param.variants[0];
                        } else if (param is SingleSelectParameter) {
                          param.currentValue = param.variants.first;
                        } else if (param is MultiSelectParameter) {
                          param.selectedVariants = [];
                        } else if (param is InputParameter) {
                          param.value = null;
                        } else if (param is TextParameter) {
                          param.value = '';
                        }
                      }
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        localizations.resetEverything,
                        style: AppTypography.font12gray,
                      ),
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.price,
                  style: AppTypography.font16black.copyWith(fontSize: 18),
                ),
                UnderLineTextField(
                  width: double.infinity,
                  hintText: '',
                  controller: priceController,
                  keyBoardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                  priceType: _priceType,
                  availableTypes: _availableTypes,
                  onChangePriceType: (priceType) {
                    setState(() {
                      _priceType = priceType;
                    });
                  },
                  validator: (value) {
                    final n = double.tryParse(priceController.text.replaceAll(',', '.')) ?? -1;
                    if (n <= 0) {
                      _parametersRequired['price'] = false;
                      return localizations.errorReviewOrEnterOther;
                    }
                    _parametersRequired['price'] = true;
                    return null;
                  },
                  onChange: (String value) {
                    if (priceController.text.contains(',')) {
                      priceController.text = priceController.text.replaceAll(',', '.');
                    }
                    final n = double.tryParse(priceController.text.replaceAll(',', '.')) ?? -1;
                    if (n <= 0) {
                      _parametersRequired['price'] = false;
                    } else {
                      _parametersRequired['price'] = true;
                    }
                    _formKey.currentState?.validate();
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._parametersList
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: buildParameter(e),
                              ))
                          .toList(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: CustomTextButton.orangeContinue(
          width: MediaQuery.of(context).size.width - 30,
          text: localizations.continue_,
          callback: () async {
            if (buttonActive) {
              repository.setPrice(_priceType.fromPriceString(priceController.text) ?? 0);

              repository.setPriceType(_priceType);
              await repository.setInfoFormItem(context);
              Navigator.pushNamed(
                context,
                AppRoutesNames.announcementCreatingPlace,
              );
            }
          },
          active: buttonActive,
        ),
      ),
    );
  }

  bool get buttonActive {
    bool allTrue = _parametersRequired.values.every((value) => value == true);
    return allTrue;
  }

  (Widget, bool?) _buildField(Parameter parameter) {
    final localizations = AppLocalizations.of(context)!;
    late Widget child;
    bool? isValid;

    if (parameter is SelectParameter) {
      isValid = _parametersRequired[parameter.key];
      if (parameter.variants.length > 3) {
        child = SelectParameterBottomSheet(
          title: parameter.name,
          selected: parameter.currentValue.name,
          child: SelectParameterWidget(
            parameter: parameter,
            isClickable: false,
            onChange: () => setState(() {
              _parametersRequired[parameter.key] = parameter.currentValue.key != emptyParameter;
              // _formKey.currentState?.validate();
            }),
          ),
        );
      } else {
        child = SelectParameterWidget(
          parameter: parameter,
          isClickable: false,
          onChange: () => setState(() {
            _parametersRequired[parameter.key] = parameter.currentValue.key != emptyParameter;
            // _formKey.currentState?.validate();
          }),
        );
      }
    } else if (parameter is SingleSelectParameter) {
      isValid = _parametersRequired[parameter.key];
      if (parameter.variants.length > 3) {
        child = SelectParameterBottomSheet(
          title: parameter.name,
          selected: parameter.currentValue.name,
          child: SelectParameterWidget(
            parameter: parameter,
            isClickable: false,
            onChange: () => setState(() {
              _parametersRequired[parameter.key] = parameter.currentValue.key != emptyParameter;
              // _formKey.currentState?.validate();
            }),
          ),
        );
      } else {
        child = SelectParameterWidget(
          parameter: parameter,
          isClickable: false,
          onChange: () => setState(() {
            _parametersRequired[parameter.key] = parameter.currentValue.key != emptyParameter;
            isValid = _parametersRequired[parameter.key];
            // _formKey.currentState?.validate();
          }),
        );
      }
    } else if (parameter is MultiSelectParameter) {
      if (parameter.variants.length > 3) {
        String selected = localizations.notSpecified;
        if (parameter.selectedVariants.length == 1) {
          selected = parameter.selectedVariants.first.name;
        } else if (parameter.selectedVariants.length > 1) {
          selected = '${localizations.selected}: ${parameter.selectedVariants.length}';
        }
        child = SelectParameterBottomSheet(
          title: parameter.name,
          selected: selected,
          child: MultipleCheckboxPicker(
            parameter: parameter,
            wrapDirection: Axis.vertical,
            onChange: () => setState(() {}),
          ),
        );
      } else {
        child = MultipleCheckboxPicker(
          parameter: parameter,
          wrapDirection: Axis.vertical,
          onChange: () => setState(() {}),
        );
      }
    } else if (parameter is InputParameter) {
      child = Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: InputParameterWidget(
          parameter: parameter,
          onChange: () => setState(() {
            _parametersRequired[parameter.key] = parameter.currentValue != null && parameter.currentValue != '';
            _formKey.currentState?.validate();
          }),
          validator: (value) {
            if (value == null) {
              _parametersRequired[parameter.key] = false;
              return localizations.errorReviewOrEnterOther;
            }
            final n = double.tryParse(value.replaceAll(',', '.'));
            if (n == null) {
              _parametersRequired[parameter.key] = false;
              return localizations.errorReviewOrEnterOther;
            }
            _parametersRequired[parameter.key] = true;
            return null;
          },
        ),
      );
    } else {
      child = const SizedBox.shrink();
    }
    return (child, isValid);
  }

  Widget buildParameter(Parameter parameter) {
    final localizations = AppLocalizations.of(context)!;

    final (child, isValid) = _buildField(parameter);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (isValid == false)
          Text(
            localizations.errorReviewOrEnterOther,
            style: AppTypography.font12normal.copyWith(
              color: const Color(0xFFCC6E69),
              fontSize: 13,
            ),
          ),
      ],
    );
  }
}
