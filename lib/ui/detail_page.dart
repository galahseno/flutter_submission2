import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:submission_1/bloc/detail/detail_bloc.dart';
import 'package:submission_1/common/styles.dart';
import 'package:submission_1/data/api/api_service.dart';
import 'package:submission_1/data/model/remote/detail/drinks.dart';
import 'package:submission_1/data/model/remote/detail/foods.dart';
import 'package:submission_1/ui/widgets/error_widget.dart';
import 'package:submission_1/ui/widgets/icon_box.dart';

class DetailPage extends StatefulWidget {
  static const routeName = 'detail_page';

  final String id;

  DetailPage({required this.id});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Icon favoriteIcon = Icon(Icons.favorite_border);
  TextEditingController nameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

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
                  return _showBottomSheet();
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
                          setDummyFavorite();
                        },
                        child: IconBox(
                          width: 45,
                          height: 45,
                          child: favoriteIcon,
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
                    return _buildDrinksItems(context,
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
                    return _buildFoodsItems(context,
                        state.detailResponse.restaurant.menus.foods[index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet() {
    return BlocBuilder<DetailBloc, DetailState>(
      builder: (_, state) {
        if (state is DetailInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is DetailLoaded) {
          return _buildCostumerReviews(state);
        } else {
          return buildErrorWidget((state as DetailError).message);
        }
      },
    );
  }

  Widget _buildCostumerReviews(DetailLoaded state) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: _checkReviewsLength(state),
        ),
      ),
    );
  }

  List<Widget> _checkReviewsLength(DetailLoaded state) {
    final size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();

    List<Widget> reviewName = [];
    for (var value in state.detailResponse.restaurant.customerReviews) {
      reviewName.add(IconBox(
          child: Container(
            margin: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value.name!),
                Text(value.date!),
                Text(
                  value.review!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          width: size.width - 40,
          height: 100));
    }
    reviewName.add(
      ElevatedButton.icon(
        icon: Icon(Icons.rate_review),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Center(
                    child: Text('Add your review'),
                  ),
                  content: Container(
                    width: double.infinity,
                    height: 200,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              } else if (value.length < 5) {
                                return 'Name must be at least 5 character';
                              }
                              return null;
                            },
                            controller: nameController,
                            cursorColor: secondaryColor,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.account_box_outlined,
                                  color: secondaryColor,
                                ),
                                hintText: 'Input your name here . . '),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              } else if (value.length < 10) {
                                return 'Review must be at least 10 character';
                              }
                              return null;
                            },
                            controller: reviewController,
                            maxLines: 3,
                            cursorColor: secondaryColor,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.rate_review,
                                  color: secondaryColor,
                                ),
                                hintText: 'Input your review here . .'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(secondaryColor),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(secondaryColor),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          context.read<DetailBloc>().add(
                                PostDetailReviewEvent(
                                  id: state.detailResponse.restaurant.id,
                                  name: nameController.text,
                                  review: reviewController.text,
                                ),
                              );
                        }
                      },
                      child: Text('Post Review'),
                    ),
                  ],
                );
              });
          nameController.clear();
          reviewController.clear();
        },
        label: Text('Add Reviews'),
        style: ElevatedButton.styleFrom(primary: secondaryColor),
      ),
    );
    return reviewName;
  }

  List<Widget> _checkCategoriesLength(DetailLoaded state) {
    List<Widget> categoriesName = [];
    for (var value in state.detailResponse.restaurant.categories) {
      categoriesName
          .add(IconBox(child: Text(value.name), width: 75, height: 35));
    }
    return categoriesName;
  }

  Widget _buildDrinksItems(BuildContext context, Drinks drinks) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: Column(
        children: [
          Lottie.asset(
            'assets/drinks.json',
            repeat: true,
            reverse: true,
            animate: true,
            width: 125,
            height: 100,
          ),
          Text(drinks.name),
        ],
      ),
    );
  }

  Widget _buildFoodsItems(BuildContext context, Foods foods) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: Column(
        children: [
          Lottie.asset(
            'assets/foods.json',
            repeat: true,
            reverse: true,
            animate: true,
            width: 125,
            height: 100,
          ),
          Text(foods.name),
        ],
      ),
    );
  }

  void setDummyFavorite() {
    setState(() {
      if (favoriteIcon.icon == Icons.favorite_border) {
        favoriteIcon = Icon(
          Icons.favorite,
          color: secondaryColor,
        );
        final snackBar = SnackBar(content: Text('Add to Dummy Favorite'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        favoriteIcon = Icon(Icons.favorite_border);
        final snackBar = SnackBar(content: Text('Delete from Dummy Favorite'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
}
