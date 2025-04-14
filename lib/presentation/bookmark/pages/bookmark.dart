import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/bottomNavigationBar/bottomNavigationBar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/bookmark_bloc.dart';
import '../bloc/bookmark_state.dart';
import '../widgets/serviceCard.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {

  final ScrollController _scrollController = ScrollController();
  bool _isNavBarVisible = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isNavBarVisible) {
          setState(() => _isNavBarVisible = false);
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isNavBarVisible) {
          setState(() => _isNavBarVisible = true);
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: buildLeadingIconButton(() => context.go('/home')),
            title: const Text(
              "Bookmark",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            actions: [buildActionIconButton(() {})],
          ),

          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: state is BookmarkLoaded
                    ? (state.bookmarkedServiceProviders.isEmpty
                    ? const Center(child: Text('No bookmarks found.'))
                    : ListView.builder(
                  controller: _scrollController,
                  clipBehavior: Clip.none,
                  itemCount: state.bookmarkedServiceProviders.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ServiceCard(
                      serviceProvider: state.bookmarkedServiceProviders[index],
                    ),
                  ),
                ))
                    : state is BookmarkLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const Center(child: Text('Something went wrong.')),
              ),
            ],
          ),



          bottomNavigationBar: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isNavBarVisible ? kBottomNavigationBarHeight : 0,
            // Animate height
            child: Wrap(
              children: [
                Opacity(
                  opacity: _isNavBarVisible ? 1.0 : 0.0, // Fade effect
                  child: BottomNavigationBarSection(),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget buildLeadingIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(left: 15),
    child: circleIconButton(Icons.arrow_back, onPressed),
  );

  Widget buildActionIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(right: 15),
    child: circleIconButton(Icons.search, onPressed),
  );

  Widget circleIconButton(IconData icon, VoidCallback onPressed) => Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.darkGrey, width: 1),
      color: Colors.white,
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.black, size: 20),
      onPressed: onPressed,
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
    ),
  );
}
