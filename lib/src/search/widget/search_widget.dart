import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/core/model/user.dart';
import 'package:flutter_twitter_clone/src/search/cubit/user_search_cubit.dart';
import 'package:flutter_twitter_clone/src/search/widget/search_item.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  var hasValue = false;
  var textController = TextEditingController();
  List<UserModel> listOfUsers = [];
  List<UserModel> searchedUsers = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    super.initState();
  }

  void fetchData() {
    final cubit = context.read<UserSearchCubit>();
    cubit.searchUser();
  }

  _searchUser(String value) {
    searchedUsers = [];
    if (textController.text != "") {
      for (var user in listOfUsers) {
        var name = user.name!.toLowerCase();
        if (name.contains(textController.text.toLowerCase())) {
          searchedUsers.add(user);
        }
      }
      setState(() {});
    } else {
      setState(() {
        searchedUsers = [];
      });
    }
  }

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
            onChanged: _searchUser,
          ),
          actions: [
            hasValue ? const Icon(Icons.close) : const SizedBox.shrink(),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: BlocBuilder<UserSearchCubit, UserSearchState>(
          builder: (context, state) {
            if (state is UserSearchData) {
              var data = state.data;
              listOfUsers = data;
            }
            return ListView.separated(
              itemCount: searchedUsers.length,
              itemBuilder: (ctx, index) {
                return SearchItem(user: searchedUsers[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          },
        ),
      ),
    );
  }
}
