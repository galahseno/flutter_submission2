import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_1/bloc/detail/detail_bloc.dart';
import 'package:submission_1/common/styles.dart';
import 'package:submission_1/ui/widgets/error_widget.dart';
import 'package:submission_1/ui/widgets/icon_box.dart';

showBottomSheetReviews(BuildContext context) {
  return BlocBuilder<DetailBloc, DetailState>(
    builder: (_, state) {
      if (state is DetailInitial) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is DetailLoaded) {
        return _buildCostumerReviews(state, context);
      } else {
        return buildErrorWidget((state as DetailError).message);
      }
    },
  );
}

Widget _buildCostumerReviews(DetailLoaded state, BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: _checkReviewsLength(state, context),
      ),
    ),
  );
}

List<Widget> _checkReviewsLength(DetailLoaded state, BuildContext context) {
  final size = MediaQuery.of(context).size;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  List<Widget> reviewName = [];
  for (var value in state.detailResponse.restaurant.customerReviews) {
    reviewName.add(IconBox(
        child: Container(
          margin: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value.name ?? '-'),
              Text(value.date ?? '-'),
              Text(
                value.review ?? '-',
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
                          MaterialStateProperty.all(Colors.green[800]),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Colors.green[800]),
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
