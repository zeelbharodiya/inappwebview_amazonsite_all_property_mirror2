import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class Site1 extends StatefulWidget {
  const Site1({Key? key}) : super(key: key);

  @override
  State<Site1> createState() => _Site1State();
}

class _Site1State extends State<Site1> {
  @override

  late PullToRefreshController  pullToRefreshController;
  InAppWebViewController? inAppWebViewController;
  int currentitem = 0;
  List Bookmark = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.black),
      onRefresh: () async {
        await inAppWebViewController?.reload();
      }
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse("https://www.amazon.in/"),
          ),
          onWebViewCreated: (controller) {
            setState(() {
              inAppWebViewController = controller;
            });
          },
          pullToRefreshController: pullToRefreshController,
          onLoadStop: (controller , url) async {
            await pullToRefreshController.endRefreshing();
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(onPressed: () async {
            Uri? uri = await inAppWebViewController?.getUrl();

            String url = uri.toString();

            Bookmark.add(url);
          }, child: Icon(Icons.bookmark_add_outlined),),
          SizedBox(width: 15,),
          FloatingActionButton(onPressed: () {
            showDialog(context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Center(child: Text("Bookmark")),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...Bookmark.map((e) =>
                              GestureDetector(
                                  onTap :() async {
                                    Navigator.pop(context);

                                    await inAppWebViewController?.loadUrl(urlRequest: URLRequest(url: Uri.parse(e),),);
                                  },
                                  child: Column(
                                    children: [
                                      Text(e),
                                      Text("------------------------------------------"),
                                    ],
                                  )),
                          ).toList(),
                        ],
                      ),
                    ),
                  ),);
          }, child: Icon(Icons.bookmark),),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(color: Colors.green),
        currentIndex: currentitem,
        onTap: (val) {
          setState(() {
            currentitem = val;
          });
        },
        items: [
          BottomNavigationBarItem(icon: GestureDetector(
              onTap: () {
                setState(() async {
                  await inAppWebViewController?.goBack();
                });
              },
              child: Icon(Icons.arrow_back_ios)), label: "",),
          BottomNavigationBarItem(icon: GestureDetector(
              onTap: () {
                setState(() async {
                  await inAppWebViewController?.goForward();
                });
              },
              child: Icon(Icons.arrow_forward_ios,)), label: ""),
          BottomNavigationBarItem(icon: GestureDetector(
              onTap: () {
                setState(() async {
                  await inAppWebViewController?.loadUrl(urlRequest: URLRequest(
                      url: Uri.parse("https://www.amazon.in/")));
                });
              },
              child: Icon(Icons.home_outlined,)), label: ""),
          BottomNavigationBarItem(icon: GestureDetector(
              onTap: () {
                setState(() async {
                  await inAppWebViewController?.reload();
                });
              },
              child: Icon(Icons.refresh,)), label: ""),
          BottomNavigationBarItem(icon: GestureDetector(
              onTap: () {
                setState(() async {
                  await inAppWebViewController?.reload();
                });
              },
              child: Icon(Icons.close,)), label: ""),
        ],
      ),
    );
  }
}
