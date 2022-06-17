import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfx/pdfx.dart';
import 'package:testbook/cubit/cubit/color_cubit.dart';

import '../core/components/mundarija.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({Key? key}) : super(key: key);

  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  static int _initialPage = 2;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = true;
  late PdfControllerPinch _pdfController;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openAsset('assets/yoll.pdf'),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).primaryColor,
        title: RichText(
          text: const TextSpan(text: """
ТЕОРЕТИЧЕСКИЕ ОСНОВЫ ОТДЕЛКИ
ВОЛОКНИСТЫХ МАТЕРИАЛОВ"""),
        ),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (e) async {
                if (e == 1) {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: DraggableScrollbar.semicircle(
                              controller: _controller,
                              child: ListView.builder(
                                controller: _controller,
                                itemBuilder: (_, __) {
                                  return ListTile(
                                    title: Text(mundarija[__][0].toString(),
                                        style: TextStyle(
                                            fontWeight:
                                                mundarija[__][0][0] == ' '
                                                    ? FontWeight.bold
                                                    : FontWeight.w300)),
                                    trailing: Text(mundarija[__][0][0] == ' '
                                        ? ""
                                        : mundarija[__][1].toString()),
                                    onTap: () {
                                      setState(() {
                                        _pdfController.goToPage(
                                            pageNumber: mundarija[__][1]);
                                      });
                                    },
                                  );
                                },
                                itemCount: mundarija.length,
                              ),
                            ));
                      });
                    },
                  );
                } else if (e == 2) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text(
                            "Bu loyiha Foziljonov Abdulloh tomonidan 2022-yilda ishlab chiqildi",
                          ),
                        );
                      });
                } else if (e == 3) {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return BlocBuilder<ColorCubit, ColorState>(
                        builder: (context, state) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: ListView.builder(
                              itemBuilder: (_, __) {
                                return ListTile(
                                  title: Text(
                                    ranglarim[__][1].toString(),
                                  ),
                                  trailing: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Color(
                                        int.parse(ranglarim[__][0].toString())),
                                  ),
                                  onTap: () async {
                                    context
                                        .read<ColorCubit>()
                                        .changeColor(ranglarim[__][0]);
                                  },
                                );
                              },
                              itemCount: ranglarim.length,
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text("Тема"),
                      value: 1,
                    ),
                    const PopupMenuItem(
                      child: Text("О проекте"),
                      value: 2,
                    ),
                    const PopupMenuItem(
                      child: Text("Цвета"),
                      value: 3,
                    )
                  ])
        ],
      ),
      body: PdfViewPinch(
        documentLoader: const Center(child: CircularProgressIndicator()),
        pageLoader: const Center(child: CircularProgressIndicator()),
        controller: _pdfController,
        onDocumentLoaded: (document) {
          setState(() {
            _allPagesCount = document.pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            _actualPageNumber = page;
          });
        },
      ),
      floatingActionButton: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  heroTag: '+',
                  child: const Text('+'),
                  onPressed: () async {
                    _pdfController.nextPage(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 100),
                    );
                  }),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).primaryColor),
                child: FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    heroTag: '0',
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '$_actualPageNumber/$_allPagesCount',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    onPressed: () async {}),
              ),
              FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  heroTag: '-',
                  child: const Text('-'),
                  onPressed: () async {
                    _pdfController.previousPage(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 100),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
