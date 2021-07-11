import 'package:cached_network_image/cached_network_image.dart';
import 'package:dogbreadapp/model/breedModel.dart';
import 'package:dogbreadapp/services/api_imp.dart';
import 'package:dogbreadapp/utils/app_utils.dart';
import 'package:dogbreadapp/viewmodels/dashboardViewModel.dart';
import 'package:dogbreadapp/views/base/base_widget.dart';
import 'package:dogbreadapp/views/breed_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List<BreedModel> _data = List();
  List<BreedModel> _searchData = List();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int count = 0;
  int searchCount = 0;
  TextEditingController searchCtr = TextEditingController();
  void _onRefresh(DashBoardViewModel model) async {
    model.setLoading(true);
    _data.clear();
    List<dynamic> res = await model.getPaginatedData(10, 0);

    if (mounted)
      setState(() {
        if (res != null) {
          if (res.length > 0) {
            setState(() {
              res.forEach((element) {
                _data.add(BreedModel.fromJson(element));
              });
            });
            count = 0;
          }
        }
      });
    model.setLoading(false);

    _refreshController.refreshCompleted();
  }

  void _onLoading(DashBoardViewModel model) async {
    if (_searchData.length > 0) {
      List<dynamic> res = await model.getPaginatedDataByName(10, searchCount,
          value: searchCtr.text);

      if (mounted)
        setState(() {
          if (res != null) {
            if (res.length > 0) {
              setState(() {
                res.forEach((element) {
                  _searchData.add(BreedModel.fromJson(element));
                });
              });
              searchCount = searchCount + 1;
            }
          }
        });
    } else {
      List<dynamic> res = await model.getPaginatedData(10, count);

      if (mounted)
        setState(() {
          if (res != null) {
            if (res.length > 0) {
              setState(() {
                res.forEach((element) {
                  _data.add(BreedModel.fromJson(element));
                });
              });
              count = count + 1;
            }
          }
        });
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BaseWidget<DashBoardViewModel>(
        model: DashBoardViewModel(Provider.of<ApiImp>(context)),
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
                appBar: GFAppBar(
                  searchBar: true,
                  searchController: searchCtr,
                  title: Text(
                    "Dog Breeds",
                    style: TextStyle(fontSize: height * 0.03),
                  ),
                  centerTitle: true,
                  onTap: () {
                    searchCtr.clear();
                    if (_searchData.length > 0) {
                      model.setLoading(true);
                      setState(() {
                        searchCount = 0;
                        _searchData.clear();
                      });
                      Future.delayed(Duration(milliseconds: 500), () {
                        model.setLoading(false);
                      });
                    }
                  },
                  onSubmitted: (value) async {
                    model.setLoading(true);
                    List<dynamic> res =
                        await model.getPaginatedDataByName(10, 0, value: value);
                    if (res != null) {
                      if (res.length > 0) {
                        setState(() {
                          res.forEach((element) {
                            _searchData.add(BreedModel.fromJson(element));
                          });
                        });
                        searchCount = searchCount + 1;
                      }
                    }

                    model.setLoading(false);
                  },
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: new LinearGradient(
                          colors: [
                            const Color(0xFF3366FF),
                            const Color(0xFF00CCFF),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 3.0),
                          stops: [0.0, 7.0],
                          tileMode: TileMode.repeated),
                    ),
                  ),
                ),
                // appBar: AppBar(
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
          List<dynamic> res = await model.getPaginatedData(10, 0);

          if (res != null) {
            if (res.length > 0) {
              setState(() {
                res.forEach((element) {
                  _data.add(BreedModel.fromJson(element));
                });
              });
              count = count + 1;
            }
          }

          model.setLoading(false);
        });
  }

  getRespectedView(double height, double width, DashBoardViewModel model) {
    if (model.loading) {
      return MyLoader();
    } else {
      return Padding(
        padding: EdgeInsets.all(width * 0.03),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (model.noRecordFound) {
                body = Text("No more record");
              } else if (mode == LoadStatus.idle) {
                body = loadingbar(color: Colors.blue, size: height * 0.02);
              } else if (mode == LoadStatus.loading) {
                body = loadingbar(color: Colors.blue, size: height * 0.03);
              } else if (mode == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("release to load more");
              } else {
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                margin: EdgeInsets.only(top: 15, bottom: 10),
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: () {
            _onRefresh(model);
          },
          onLoading: () {
            _onLoading(model);
          },
          child: model.noRecordFound &&
                  ((_data.length <= 0 && searchCount == 0) ||
                      (searchCtr.text.length > 0 && _searchData.length <= 0))
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search),
                    Text(
                      "No Record Found",
                      style: TextStyle(fontSize: height * 0.02),
                    )
                  ],
                )
              : ListView.separated(
                  itemBuilder: (context, itemIndex) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BreedDetails(
                                    id: _searchData.isNotEmpty
                                        ? _searchData[itemIndex].id
                                        : _data[itemIndex].id)));
                      },
                      child: BreedCard(
                          height: height,
                          width: width,
                          data: _searchData.isNotEmpty
                              ? _searchData[itemIndex]
                              : _data[itemIndex]),
                    );
                  },
                  separatorBuilder: (context, sepIndex) {
                    return spacer(
                      height: 10,
                    );
                  },
                  itemCount: _searchData.isNotEmpty
                      ? _searchData.length
                      : _data.length),
        ),
      );
    }
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
