import 'package:click_gujrat/Pages/PlaceInfo/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/place_model.dart';


class SearchDialog extends StatefulWidget {
  final List<Place> places;

  const SearchDialog({Key? key, required this.places}) : super(key: key);

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final List<Place> _searchedPlaces = [];
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      title: TextField(
        onChanged: filterSearchResults,
        controller: searchController,
        decoration: const InputDecoration(
            labelText: "Search",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)))),
      ),
      content: SizedBox(
        height: Get.height / 5,
        width: Get.width * 4/5,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _searchedPlaces.length,
          itemBuilder: (BuildContext context, int index) {
            Place _place = _searchedPlaces[index];
            return Ink(
              child: InkWell(
                onTap: () {
                  Get.back();
                  Get.to(() => PlaceDetail(id: _place.id!));
                },
                child: ListTile(
                  title: Text(_place.title),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        OutlinedButton(onPressed: Get.back, child: const Text("Cancel")),
      ],
      actionsAlignment: MainAxisAlignment.end,
    );
  }

  void filterSearchResults(String query) {
    List<Place> dummySearchList = [];
    dummySearchList.addAll(widget.places);
    if(query.isNotEmpty) {
      List<Place> dummyListData = [];
      for (Place place in widget.places) {
        if (place.title.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(place);
        }
      }
      setState(() {
        _searchedPlaces.clear();
        _searchedPlaces.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _searchedPlaces.clear();
        _searchedPlaces.addAll(widget.places);
      });
    }
  }
}
