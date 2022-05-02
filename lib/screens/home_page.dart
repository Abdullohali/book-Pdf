import 'dart:async';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testbook/core/components/mundarija.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.pdfAssetPath}) : super(key: key);
  final String pdfAssetPath;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();

  final StreamController<String> _pageCountController =
      StreamController<String>();

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.h,
        title: RichText(
          text: const TextSpan(text: """
ТЕОРЕТИЧЕСКИЕ ОСНОВЫ ОТДЕЛКИ
ВОЛОКНИСТЫХ МАТЕРИАЛОВ"""),
        ),
        actions: [
          PopupMenuButton(
              onSelected: (e) async {
                if (e == 1) {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                          height: 400.h,
                          child: FutureBuilder<PDFViewController>(
                              future: _pdfViewController.future,
                              builder: (_,
                                  AsyncSnapshot<PDFViewController> snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return DraggableScrollbar.semicircle(
                                    backgroundColor: Colors.green,
                                    controller: _controller,
                                    child: ListView.builder(
                                      controller: _controller,
                                      itemBuilder: (_, __) {
                                        return ListTile(
                                          title: Text(
                                              mundarija[__][0].toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                      mundarija[__][0][0] == ' '
                                                          ? FontWeight.bold
                                                          : FontWeight.w300)),
                                          trailing: Text(mundarija[__][0][0] ==
                                                  ' '
                                              ? ""
                                              : mundarija[__][1].toString()),
                                          onTap: () async {
                                            final PDFViewController
                                                pdfController = snapshot.data!;
                                            int currentPage = mundarija[__][1];
                                            if (currentPage >= 0) {
                                              await pdfController
                                                  .setPage(currentPage - 1);
                                            }
                                          },
                                        );
                                      },
                                      itemCount: mundarija.length,
                                    ),
                                  );
                                }
                                return Container();
                              }));
                    },
                  );
                } else if (e == 2) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text(
                              "Bu loyiha Foziljonov Abdulloh tomonidan 2022-yilda ishlab chiqildi"),
                        );
                      });
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
                    )
                  ])
        ],
      ),
      body: PDF(
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
        onPageChanged: (int? current, int? total) =>
            _pageCountController.add('${current! + 1} - $total'),
        onViewCreated: (PDFViewController pdfViewController) async {
          _pdfViewController.complete(pdfViewController);
          final int currentPage = await pdfViewController.getCurrentPage() ?? 0;
          final int? pageCount = await pdfViewController.getPageCount();
          _pageCountController.add('${currentPage + 1} - $pageCount');
        },
      ).fromAsset(
        widget.pdfAssetPath,
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _pdfViewController.future,
        builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Scrollbar(
              child: Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FloatingActionButton(
                        heroTag: '+',
                        child: const Text('+'),
                        onPressed: () async {
                          final PDFViewController pdfController =
                              snapshot.data!;
                          final int currentPage =
                              (await pdfController.getCurrentPage())! + 1;
                          if (currentPage >= 0) {
                            await pdfController.setPage(currentPage);
                          }
                        }),
                    SizedBox(
                      height: 70.h,
                      width: 70.w,
                      child: FloatingActionButton(
                          heroTag: '-',
                          child: StreamBuilder<String>(
                              stream: _pageCountController.stream,
                              builder: (_, AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data!);
                                }
                                return const SizedBox();
                              }),
                          onPressed: () async {}),
                    ),
                    FloatingActionButton(
                        heroTag: '-',
                        child: const Text('-'),
                        onPressed: () async {
                          final PDFViewController pdfController =
                              snapshot.data!;
                          final int currentPage =
                              (await pdfController.getCurrentPage())! - 1;
                          if (currentPage >= 0) {
                            await pdfController.setPage(currentPage);
                          }
                        })
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
