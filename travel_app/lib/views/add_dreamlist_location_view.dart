import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dreamlist_viewmodel.dart';

class AddDreamlistLocation extends StatelessWidget {
  const AddDreamlistLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      final viewModel = DreamListViewModel();
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
