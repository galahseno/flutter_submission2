import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_1/bloc/detail/detail_bloc.dart';
import 'package:submission_1/bloc/favorite/dummy_favorite_bloc.dart';
import 'package:submission_1/common/styles.dart';
import 'package:submission_1/data/api/api_service.dart';
import 'package:submission_1/ui/bottom_sheet.dart';
import 'package:submission_1/ui/widgets/drinks_item.dart';
import 'package:submission_1/ui/widgets/error_widget.dart';
import 'package:submission_1/ui/widgets/foods_item.dart';
import 'package:submission_1/ui/widgets/icon_box.dart';

class DetailPage extends StatefulWidget {
  static const routeName = 'detail_page';

  final String id;

  DetailPage({required this.id});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();

    context.read<DetailBloc>().add(LoadedDetailEvent(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryColor,
          child: Icon(
            Icons.rate_review,
            color: primaryColor,
            size: 30,
          ),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return showBottomSheetReviews(context);
                });
          },
        ),
        body: BlocBuilder<DetailBloc, DetailState>(
          builder: (_, state) {
            if (state is DetailInitial) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is DetailLoaded) {
              return _buildDetailContent(state);
            } else {
              return buildErrorWidget((state as DetailError).message);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailContent(DetailLoaded state) {
    final size = MediaQuery.of(context).size;
    bool _favorite = false;

    return SingleChildScrollView(
      child: Container(
        color: primaryColor,
        width: size.width,
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: state.detailResponse.restaurant.id,
                  child: Image.network(ApiService.baseImgUrl +
                      state.detailResponse.restaurant.pictureId),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: IconBox(
                          width: 45,
                          height: 45,
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                      IconBox(
                        width: 150,
                        height: 55,
                        child: Text(
                          state.detailResponse.restaurant.name,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _favorite = !_favorite;
                          setDummyFavorite(_favorite);
                          context
                              .read<DummyFavoriteBloc>()
                              .add(FavoriteDummyEvent(favorite: _favorite));
                        },
                        child: IconBox(
                          width: 45,
                          height: 45,
                          child: BlocBuilder<DummyFavoriteBloc,
                              DummyFavoriteState>(
                            builder: (_, state) {
                              if (state is DummyFavoriteInitial) {
                                return Icon(Icons.favorite_border);
                              } else {
                                return Icon(
                                  Icons.favorite,
                                  color: secondaryColor,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _checkCategoriesLength(state),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  state.detailResponse.restaurant.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            Container(
              height: 125,
              child: ListView.builder(
                  itemCount:
                      state.detailResponse.restaurant.menus.drinks.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildDrinksItems(context,
                        state.detailResponse.restaurant.menus.drinks[index]);
                  }),
            ),
            Container(
              height: 125,
              child: ListView.builder(
                  itemCount: state.detailResponse.restaurant.menus.foods.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildFoodsItems(context,
                        state.detailResponse.restaurant.menus.foods[index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _checkCategoriesLength(DetailLoaded state) {
    List<Widget> categoriesName = [];
    for (var value in state.detailResponse.restaurant.categories) {
      categoriesName
          .add(IconBox(child: Text(value.name), width: 75, height: 35));
    }
    return categoriesName;
  }

  void setDummyFavorite(bool favorite) {
    if (favorite) {
      final snackBar = SnackBar(
        content: Text('Add to Dummy Favorite'),
        backgroundColor: Colors.green[300],
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text('Delete from Dummy Favorite'),
        backgroundColor: Colors.green[300],
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
