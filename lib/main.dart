import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_1/bloc/restaurant/list_restaurant_bloc.dart';
import 'package:submission_1/bloc/search/search_bloc.dart';
import 'package:submission_1/common/styles.dart';
import 'package:submission_1/data/source/repository.dart';
import 'package:submission_1/ui/home_page.dart';
import 'package:submission_1/ui/search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ListRestaurantBloc>(
          create: (_) => ListRestaurantBloc(
            Repository(),
          ),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(
            Repository(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Restaurant',
        theme: ThemeData(
          primaryColor: primaryColor,
          accentColor: secondaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
        ),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          // DetailPage.routeName: (context) => DetailPage(
          //       restaurants:
          //           ModalRoute.of(context)?.settings.arguments as Restaurants,
          //     ),
          SearchPage.routeName: (context) => SearchPage(),
        },
      ),
    );
  }
}
