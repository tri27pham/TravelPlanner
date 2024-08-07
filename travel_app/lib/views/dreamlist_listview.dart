// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodels/dreamlist_viewmodel.dart'; // Import the ViewModel

// class BucketListListView extends StatelessWidget {
//   const BucketListListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(
//           top: -35,
//           left: 0,
//           right: 0,
//           child: Image.asset(
//             'assets/grandcanyon.png',
//             fit: BoxFit.fitWidth,
//             height: MediaQuery.of(context).size.height * 0.5,
//           ),
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: AnimatedContainer(
//             duration: Duration(milliseconds: 200),
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height * 0.8,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(60.0),
//                 topRight: Radius.circular(60.0),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   offset: Offset(0, -2),
//                   blurRadius: 1,
//                   spreadRadius: 0.5,
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Container(
//                           height: 40,
//                           width: 40,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // viewModel.toggleView();
//                             },
//                             child: Icon(Icons.arrow_back_sharp),
//                             style: ElevatedButton.styleFrom(
//                               primary: Colors.grey[900],
//                               onPrimary: Colors.white,
//                               padding: EdgeInsets.zero,
//                               minimumSize: Size(35, 35),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           'Edit List',
//                           style: TextStyle(
//                               fontSize: 35, fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
//                   child: Center(
//                     child: Container(
//                       height: 30,
//                       width: MediaQuery.of(context).size.width * 0.8,
//                       // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // showBucketListDialog(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           primary: Colors.green,
//                           padding: EdgeInsets.all(0),
//                         ),
//                         child: Center(
//                           child: Padding(
//                             padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
//                                   child: Text(
//                                     'Add a location',
//                                     style: TextStyle(
//                                         fontSize: 12, color: Colors.white),
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.add_location_alt_outlined,
//                                   size: 15,
//                                   color: Colors.white,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 YourListWidget(),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

//   // Widget YourListWidget() {
//   //   return Expanded(
//   //     child: Padding(
//   //       padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//   //       child: Consumer<DreamListViewModel>(
//   //         builder: (context, viewModel, child) {
//   //           return ListView.builder(
//   //             padding: EdgeInsets.only(bottom: 10),
//   //             itemCount: viewModel.items.length,
//   //             itemBuilder: (context, index) {
//   //               final item = viewModel.items[index];
//   //               return ListItem(item, context);
//   //             },
//   //           );
//   //         },
//   //       ),
//   //     ),
//   //   );
//   // }
//   //   Widget ListItem(item, BuildContext context) {
//   //   return Align(
//   //     alignment: Alignment.topCenter,
//   //     child: Padding(
//   //       padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
//   //       child: Container(
//   //         height: MediaQuery.of(context).size.height * 0.13,
//   //         width: MediaQuery.of(context).size.width * 0.8,
//   //         decoration: BoxDecoration(
//   //           color: Color.fromARGB(255, 240, 240, 240),
//   //           borderRadius: BorderRadius.circular(10),
//   //         ),
//   //         child: Row(
//   //           children: [
//   //             Padding(
//   //               padding: EdgeInsets.all(10),
//   //               child: Container(
//   //                 height: 70,
//   //                 width: 70,
//   //                 decoration: BoxDecoration(
//   //                   color: Colors.blue,
//   //                   borderRadius: BorderRadius.circular(10),
//   //                 ),
//   //               ),
//   //             ),
//   //             Expanded(
//   //               child: Column(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 mainAxisAlignment: MainAxisAlignment.center,
//   //                 children: [
//   //                   ClipRRect(
//   //                     child: Text(
//   //                       item.title,
//   //                       overflow: TextOverflow.ellipsis,
//   //                       style: TextStyle(
//   //                         fontSize: 20,
//   //                         fontWeight: FontWeight.w500,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   ClipRRect(
//   //                     child: Text(
//   //                       item.location,
//   //                       overflow: TextOverflow.ellipsis,
//   //                       style: TextStyle(
//   //                         fontSize: 14,
//   //                         color: Colors.grey,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   Text(
//   //                     'Added on: ${item.dateAdded}',
//   //                     style: TextStyle(fontSize: 12),
//   //                   ),
//   //                   Text(
//   //                     'Added by: ${item.addedBy}',
//   //                     style: TextStyle(fontSize: 12),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }