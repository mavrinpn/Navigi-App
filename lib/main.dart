import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/registration/ui/register_screen.dart';
import 'package:smart/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'feature/home/ui/home_screen.dart';
import 'feature/login/ui/login_first_screen.dart';
import 'feature/login/ui/login_second_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.mainBackground,
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      routes: {
        '/login_first_screen': (context) => const LoginFirstScreen(),
        '/login_second_screen': (context) => const LoginSecondScreen(),
        '/register_screen' : (context) => const RegisterScreen(),
        '/home_screen' : (context) => const HomeScreen(),
      },
      color: const Color(0xff292B57),
      home: const HomePage(),
    );
  }
}

class MyRepositoryProviders extends StatelessWidget {
  MyRepositoryProviders({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
    ], child: const MyBlocProviders());
  }
}

class MyBlocProviders extends StatelessWidget {
  const MyBlocProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
    ], child: const MyApp());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: LoginFirstScreen(),
      ),
    );
  }
}