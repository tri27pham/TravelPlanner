import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels//add_profile_viewmodel.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AddProfile extends StatelessWidget {
  const AddProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      final viewModel = AddProfileViewModel();
      viewModel.profileNameController.addListener(viewModel.onModify);
      return viewModel;
    }, child: Consumer<AddProfileViewModel>(
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextFormField(
                            controller: viewModel.profileNameController,
                            decoration: InputDecoration(
                              labelText: 'Profile Name',
                              labelStyle: TextStyle(
                                fontSize: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Choose colour'),
                          ),
                          // MaterialColorPicker(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: ElevatedButton(
                    onPressed: viewModel.validProfileDetails
                        ? () {
                            viewModel.addProfile(context);
                          }
                        : null,
                    child: Text('Add Profile'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                      elevation: 0,
                      backgroundColor: viewModel.validProfileDetails
                          ? Colors.green
                          : Colors.transparent,
                      foregroundColor: viewModel.validProfileDetails
                          ? Colors.white
                          : Colors.grey[700],
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
