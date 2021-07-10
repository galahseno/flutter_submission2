import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_1/bloc/restaurant/list_restaurant_bloc.dart';
import 'package:submission_1/common/styles.dart';
import 'package:submission_1/ui/search_page.dart';
import 'package:submission_1/ui/widgets/card_restaurants.dart';
import 'package:submission_1/ui/widgets/error_widget.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _controller = ScrollController();
  double _topContainer = 0;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      _topContainer = _controller.offset / 139;
    });

    context.read<ListRestaurantBloc>().add(LoadedEvent(value: _topContainer));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          leading: Icon(
            Icons.restaurant,
            color: Colors.black,
            size: 30,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              iconSize: 30,
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.routeName);
              },
            ),
          ],
          backgroundColor: primaryColor,
          title: Center(
            child: Text(
              'Restaurants',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        body: BlocBuilder<ListRestaurantBloc, ListRestaurantState>(
          builder: (_, state) {
            if (state is ListRestaurantInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ListRestaurantLoaded) {
              return _listViewBuild(state);
            } else {
              return buildErrorWidget((state as ListRestaurantError).message);
            }
          },
        ),
      ),
    );
  }

  Widget _listViewBuild(ListRestaurantLoaded state) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      // controller: _controller,
      itemCount: (state).listRestaurant.length,
      itemBuilder: (context, index) {
        double scale = 1.0;
        if (_topContainer > 0.5) {
          scale = index + 0.8 - _topContainer;
          if (scale < 0) {
            scale = 0;
          } else if (scale > 1) {
            scale = 1;
          }
        }
        return Opacity(
          opacity: scale,
          child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()..scale(scale, scale),
            child: Align(
                heightFactor: 0.8,
                alignment: Alignment.topCenter,
                child:
                    buildRestaurantsItem(context, state.listRestaurant[index])),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
