import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dreamlist_viewmodel.dart'; // Import the ViewModel

class BucketListListView extends StatelessWidget {
  const BucketListListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DreamListViewModel(),
      child: Consumer<DreamListViewModel>(
        builder: (context, viewModel, child) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Center(
                      child: Container(
                        height: 30,
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            // showBucketListDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            padding: EdgeInsets.all(0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Text(
                                      'Add a location',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                  Icon(
                                    Icons.add_location_alt_outlined,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  YourListWidget()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget ListItem(item, BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.13,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 240, 240, 240),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      child: Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ClipRRect(
                      child: Text(
                        item.location,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // ClipRect(
                    //   child: Row(
                    //     children: [
                    //       // ClipRect(
                    //       //   child:
                    //       Flexible(
                    //         flex: 3,
                    //         child: Text(
                    //           item.title,
                    //           overflow: TextOverflow.ellipsis,
                    //           style: TextStyle(
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ),
                    //       // ),
                    //       // ClipRect(
                    //       // child:
                    //       Flexible(
                    //         flex: 1,
                    //         child: Text(
                    //           item.location,
                    //           overflow: TextOverflow.ellipsis,
                    //           style: TextStyle(
                    //             fontSize: 14,
                    //             color: Colors.grey,
                    //           ),
                    //         ),

                    //         // ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Text(
                      'Added on: ${item.dateAdded}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Added by: ${item.addedBy}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget YourListWidget() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Consumer<DreamListViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 10),
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return ListItem(item, context);
              },
            );
          },
        ),
      ),
    );
  }
}
