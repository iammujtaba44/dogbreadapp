import 'package:cached_network_image/cached_network_image.dart';
import 'package:dogbreadapp/model/breedDetailsModel.dart';
import 'package:dogbreadapp/model/breedModel.dart';
import 'package:dogbreadapp/services/api_imp.dart';
import 'package:dogbreadapp/utils/app_utils.dart';
import 'package:dogbreadapp/viewmodels/dashboardViewModel.dart';
import 'package:dogbreadapp/views/base/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BreedDetails extends StatefulWidget {
  dynamic id;
  BreedDetails({this.id});
  @override
  _BreedDetailsState createState() => _BreedDetailsState();
}

class _BreedDetailsState extends State<BreedDetails> {
  List<BreedDetailModel> _data = List();
  int count = 0;
  int searchCount = 0;
  TextEditingController searchCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BaseWidget<DashBoardViewModel>(
        model: DashBoardViewModel(Provider.of<ApiImp>(context)),
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
                // appBar: GFAppBar(
                //   searchBar: true,
                //   searchController: searchCtr,
                //   title: Text(
                //     "Dog Breeds",
                //     style: TextStyle(fontSize: height * 0.03),
                //   ),
                //   flexibleSpace: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       gradient: new LinearGradient(
                //           colors: [
                //             const Color(0xFF3366FF),
                //             const Color(0xFF00CCFF),
                //           ],
                //           begin: const FractionalOffset(0.0, 0.0),
                //           end: const FractionalOffset(1.0, 3.0),
                //           stops: [0.0, 7.0],
                //           tileMode: TileMode.repeated),
                //     ),
                //   ),
                // ),
                body: getRespectedView(height, width, model)),
          );
        },
        onModelReady: (DashBoardViewModel model) async {
          model.setLoading(true);
          List<dynamic> res = await model.getBreedDetails(widget.id);

          if (res != null) {
            if (res.length > 0) {
              setState(() {
                res.forEach((elemet) {
                  _data.add(BreedDetailModel.fromJson(elemet));
                });
              });
            }
          }

          model.setLoading(false);
        });
  }

  getRespectedView(double height, double width, DashBoardViewModel model) {
    if (model.loading) {
      return MyLoader();
    } else if (model.noRecordFound)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search),
          Text(
            "No Record Found",
            style: TextStyle(fontSize: height * 0.02),
          )
        ],
      );
    else {
      return DataCardWidget(data: _data, context: context);
    }
  }
}

class DataCardWidget extends StatelessWidget {
  const DataCardWidget({
    Key key,
    @required List<BreedDetailModel> data,
    @required this.context,
  })  : _data = data,
        super(key: key);

  final List<BreedDetailModel> _data;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: _data[0].url,
                imageBuilder: (context, imageProvider) => Container(
                  width: width,
                  height: height * 0.4,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  width: width,
                  height: height * 0.4,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: CupertinoActivityIndicator(
                    animating: true,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: width,
                  height: height * 0.4,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black45,
                        ),
                        padding: const EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                            left: height * 0.02, top: height * 0.02),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                  )),
              Positioned(
                  bottom: 0,
                  child: Container(
                      color: Colors.black45,
                      padding: const EdgeInsets.all(10),
                      margin: EdgeInsets.only(
                          left: height * 0.02, bottom: height * 0.04),
                      child: Text(
                        _data[0].breeds[0].name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w500),
                      ))),
            ],
          ),
          spacer(
            height: height * 0.02,
          ),
          getDataContainer(
              height: height,
              width: width,
              key: 'Breed For',
              data: _data[0].breeds[0].bredFor),
          getDataContainer(
              height: height,
              width: width,
              key: 'Life',
              data: _data[0].breeds[0].lifeSpan),
          getDataContainer(
              height: height,
              width: width,
              key: 'Origin',
              data: _data[0].breeds[0].origin),
          getDataContainer(
              height: height,
              width: width,
              key: 'Temperament',
              data: _data[0].breeds[0].temperament),
          getDataContainer(
              height: height,
              width: width,
              key: 'Height',
              data: _data[0].breeds[0].height.imperial),
          getDataContainer(
              height: height,
              width: width,
              key: 'Weight',
              data: _data[0].breeds[0].weight.imperial),
        ],
      ),
    );
  }

  Widget getDataContainer(
      {double height, double width, String key, String data}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.only(
        bottom: height * 0.02,
        left: height * 0.02,
        right: height * 0.02,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Wrap(
        //spacing: height * 0.005,
        runSpacing: height * 0.007,
        children: [
          Text(
            "$key : ",
            style: TextStyle(
                color: Colors.black,
                fontSize: height * 0.017,
                fontWeight: FontWeight.w500),
          ),
          Text(
            data ?? 'NA',
            style: TextStyle(
                color: Colors.black,
                fontSize: height * 0.017,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}

class BreedCard extends StatelessWidget {
  BreedCard({
    Key key,
    @required this.height,
    @required this.width,
    @required BreedModel data,
  })  : _data = data,
        super(key: key);

  final double height;
  final double width;
  final BreedModel _data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.15,
      width: width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Colors.blue,
        gradient: new LinearGradient(
            colors: [
              const Color(0xFF3366FF),
              const Color(0xFF00CCFF),
            ],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(1.0, 3.0),
            stops: [0.0, 7.0],
            tileMode: TileMode.repeated),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: _data.breedimage == null ? '' : _data.breedimage.url,
            imageBuilder: (context, imageProvider) => Container(
              width: width * 0.14,
              height: height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => CupertinoActivityIndicator(
              animating: true,
            ),
            errorWidget: (context, url, error) => Container(
              width: width * 0.14,
              height: height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
          ),
          spacer(
            width: width * 0.05,
          ),
          Container(
            width: width / 2.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _data.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: height * 0.02,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                spacer(
                  height: 5,
                ),
                Text(
                  _data.bredFor ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: height * 0.017,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          VerticalDivider(
            thickness: 2,
          ),
          spacer(
            width: width * 0.002,
          ),
          Container(
            width: width * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //  crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Height',
                  style: TextStyle(
                      fontSize: height * 0.02,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                spacer(
                  height: 5,
                ),
                Text(
                  _data.height.imperial,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: height * 0.017,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                spacer(
                  height: 5,
                ),
                Text(
                  'Weight',
                  style: TextStyle(
                      fontSize: height * 0.02,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                spacer(
                  height: 5,
                ),
                Text(
                  _data.weight.imperial,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: height * 0.017,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
