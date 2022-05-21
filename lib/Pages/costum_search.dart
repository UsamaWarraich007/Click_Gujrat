import 'package:click_gujrat/Models/place_model.dart';
import 'package:click_gujrat/Pages/PlaceInfo/place_detail.dart';
import 'package:click_gujrat/Services/location_services.dart';
import 'package:click_gujrat/Widgets/big_text.dart';
import 'package:flutter/material.dart';

import '../utils/dimentions.dart';

class CustomSearchScreen extends StatefulWidget {
  const CustomSearchScreen({Key? key}) : super(key: key);

  @override
  State<CustomSearchScreen> createState() => _CustomSearchScreenState();
}

class _CustomSearchScreenState extends State<CustomSearchScreen> {
  final titleController = TextEditingController();

  final categoryController = TextEditingController();
  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Places"),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 25, bottom: 15),
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              onChanged: (val) {
                setState(() {
                  title = val;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search by title',
              ),
            ),
            SizedBox(
              height: Dimensions.height20,
            ),
            if (titleController.text.isNotEmpty)
              Expanded(
                child: StreamBuilder<List<Place>?>(
                  stream: LocationServices().searchPlacesAsStream(title: title),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var result = snapshot.data;
                            return ListTile(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PlaceDetail(id: result![index].id!)));
                              },
                              dense: true,
                              title: Text(result![index].title),
                              contentPadding: EdgeInsets.zero,
                            );
                          });
                    }
                    return const Center(child: Text("Not found place"));
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }
}
