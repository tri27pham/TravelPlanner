// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AddDreamlistLocationViewModel extends ChangeNotifier {
//   AddDreamlistLocationViewModel() {}

//   Widget SearchBarWidget(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//       child: Center(
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 300,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 240, 240, 240),
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
//                         child: Icon(
//                           Icons.search,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       Container(
//                         width: 200,
//                         height: 50,
//                         child: TextFormField(
//                           // controller: viewModel.textEditingController,
//                           // focusNode: viewModel.mapSearchFocusNode,
//                           decoration: InputDecoration(
//                             hintText: 'Search for a location',
//                             hintStyle: TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.w300,
//                               fontSize: 13,
//                             ),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // viewModel.textEditingController.text.isNotEmpty
//                 //     ? Padding(
//                 //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//                 //         child: Container(
//                 //           width: 40,
//                 //           child: ElevatedButton(
//                 //             onPressed: () {
//                 //               viewModel.textEditingController.text = '';
//                 //               viewModel.notifyListeners();
//                 //             },
//                 //             child: Icon(Icons.arrow_back_sharp),
//                 //             style: ElevatedButton.styleFrom(
//                 //               primary: Colors.grey[900],
//                 //               onPrimary: Colors.white,
//                 //               padding: EdgeInsets.zero,
//                 //               minimumSize: Size(50, 40),
//                 //             ),
//                 //           ),
//                 //         ),
//                 //       )
//                 //     : Container(),
//               ],
//             ),
//             Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
//             AnimatedContainer(
//               duration: Duration(milliseconds: 200),
//               height: 200,
//               width: MediaQuery.of(context).size.width * 0.85,
//               padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: ListView.builder(
//                 itemCount: viewModel.places.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     color: Colors.transparent,
//                     height: MediaQuery.of(context).size.height * 0.06,
//                     width: MediaQuery.of(context).size.width,
//                     child: ListTile(
//                       onTap: () async {
//                         List<Location> locations = await locationFromAddress(
//                             viewModel.places[index].description);
//                         print(locations.last.longitude);
//                         print(locations.last.latitude);
//                       },
//                       leading: Icon(Icons.location_on),
//                       title: Text(
//                         viewModel.places[index].description,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
