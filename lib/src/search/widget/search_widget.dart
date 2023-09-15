import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  var hasValue = false;
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: textController,
            decoration: InputDecoration(
              filled: false,
              fillColor: Colors.grey.withAlpha(50),
              isDense: false,
              /* -- Text and Icon -- */
              hintText: "Search X",
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              /* -- Border Styling -- */
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45.0),
                borderSide: BorderSide.none, // BorderSide
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ), // InputDecoration
            onChanged: (value){
              setState(() {
                hasValue = value.isNotEmpty;
              });
            },
          ),
        actions: [
          hasValue ? const Icon(Icons.close) : const SizedBox.shrink(),
          const SizedBox(width: 10,)
        ],
      ),
    )
    ,
    );
  }
}
