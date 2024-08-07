import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dreamlist_viewmodel.dart';

import 'package:geocoding/geocoding.dart';

class AddDreamlistLocation extends StatelessWidget {
  const AddDreamlistLocation({super.key});

  Widget SearchBarWidget(BuildContext context) {
    final viewModel = Provider.of<DreamListViewModel>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 240),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 50,
                        child: TextFormField(
                          controller: viewModel.textEditingController,
                          // focusNode: viewModel.mapSearchFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Search for a location',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                viewModel.textEditingController.text.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Container(
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              viewModel.textEditingController.text = '';
                              viewModel.notifyListeners();
                            },
                            child: Icon(Icons.arrow_back_sharp),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[900],
                              onPrimary: Colors.white,
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 40),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView.builder(
                itemCount: viewModel.places.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      onTap: () async {
                        List<Location> locations = await locationFromAddress(
                            viewModel.places[index].description);
                        print(locations.last.longitude);
                        print(locations.last.latitude);
                      },
                      leading: Icon(Icons.location_on),
                      title: Text(
                        viewModel.places[index].description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      final viewModel = DreamListViewModel();
      viewModel.textEditingController.addListener(() => viewModel.onModify());
      return viewModel;
    }, child: Consumer<DreamListViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    foregroundColor: Colors.grey[700],
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SearchBarWidget(context),
                        // TextFormField(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Add Location'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                      elevation: 0,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      // backgroundColor: viewModel.validProfileDetails
                      //     ? Colors.green
                      //     : Colors.transparent,
                      // foregroundColor: viewModel.validProfileDetails
                      //     ? Colors.white
                      //     : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
