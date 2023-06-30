import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart/feature/create/bloc/creating/creating_anounce_cubit.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: BlocListener<CreatingAnounceCubit, CreatingAnounceState>(
        listener: (context, state) {
          if (state is CreatingSuccessState) Navigator.of(context).popUntil(ModalRoute.withName('/'));
          if (state is CreatingFailState) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ошибка')));
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitFadingCircle(
                  itemBuilder: (_, ind) {
                    return const Padding(
                      padding: EdgeInsets.all(1.8),
                      child: DecoratedBox(decoration: BoxDecoration(
                          color: AppColors.red, shape: BoxShape.circle)),
                    );
                  },
                  size: 86,
                ),
                const SizedBox(
                  height: 44,
                ),
                const Text(
                  'La modération de l\'annonce est en cours',
                  textAlign: TextAlign.center,
                  style: AppTypography.font24dark,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                    'Ne bloquez pas l\'application pendant le traitement de votre annonce',
                    textAlign: TextAlign.center,
                    style: AppTypography.font14light
                ),
                const SizedBox(height: 80,)
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
