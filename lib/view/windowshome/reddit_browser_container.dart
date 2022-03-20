import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:webview_windows/webview_windows.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class ReddBrowserContainer extends StatefulWidget {
  const ReddBrowserContainer({ Key? key }) : super(key: key);

  @override
  State<ReddBrowserContainer> createState() => _ReddBrowserContainerState();
}

class _ReddBrowserContainerState extends State<ReddBrowserContainer> {

  final _controller = WebviewController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    
    try {
      await _controller.initialize();
      _controller.url.listen((url) {
      });

      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await _controller.loadUrl('https://reddit.com');

      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (_) => ContentDialog(
                  title: const Text('Error'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Code: ${e.code}'),
                      Text('Message: ${e.message}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Continue'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      });
    }
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: ProgressRing(),
      );
    } else {
      return Column(
        children: [
          Expanded(
              child: Card(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Stack(
                    children: [
                      Webview(
                        _controller,
                        permissionRequested: _onPermissionRequested,
                      ),
                      StreamBuilder<LoadingState>(
                          stream: _controller.loadingState,
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data == LoadingState.loading) {
                              return const Center(child: ProgressRing());
                            } else {
                              return const SizedBox();
                            }
                          }),
                    ],
                  ))),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: compositeView(),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => ContentDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }  


}