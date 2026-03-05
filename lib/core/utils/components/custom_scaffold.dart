import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomScaffold extends StatefulWidget {
  final List<Widget> children;

  final bool? resize;

  final PreferredSizeWidget? appBar;
  final bool? isPage;
  final Color? scaffoldColor;
  final bool? isEdit;
  final bool? isRefreshable;
  final bool? hasFabButton;
  final Widget? fabButtonWidget;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final ScrollController? scrollController;
  final bool? isSignUpFlow;

  const CustomScaffold({
    required this.children,
    this.resize,
    this.appBar,
    this.isPage = false,
    this.scaffoldColor,
    this.isEdit = false,
    this.isRefreshable = false,
    this.hasFabButton = false,
    this.fabButtonWidget,
    this.onRefresh,
    this.onLoadMore,
    this.scrollController,
    this.isSignUpFlow = false,
  });

  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(child: AppDrawer()),
      backgroundColor: widget.scaffoldColor ?? AppColors.white,
      appBar: widget.appBar,
      resizeToAvoidBottomInset: widget.resize ?? true,
      floatingActionButton:
          widget.hasFabButton == true ? widget.fabButtonWidget : null,
      body:
          // widget.isRefreshable == true
          //     ? CustomRefreshIndicator(
          //         onRefresh: () async {
          //           await widget.onRefresh?.call();
          //         },
          //         // Add loadMore support through notification
          //         notificationPredicate: (notification) {
          //           if (notification is ScrollEndNotification) {
          //             final maxScroll = notification.metrics.maxScrollExtent;
          //             final currentScroll = notification.metrics.pixels;
          //             // Load more when scrolled to bottom
          //             if (currentScroll >= maxScroll * 0.8 &&
          //                 widget.onLoadMore != null) {
          //               widget.onLoadMore?.call();
          //               return false; // Don't trigger pull-to-refresh
          //             }
          //           }
          //           return true; // Allow pull-to-refresh
          //         },
          //         offsetToArmed: 100,
          //         builder: (context, child, controller) {
          //           return Stack(
          //             alignment: Alignment.topCenter,
          //             children: [
          //               if (controller.value > 0)
          //                 Positioned(
          //                   top: controller.value.clamp(
          //                     0.0,
          //                     150.0,
          //                   ), // Limit the value
          //                   child: Lottie.asset(
          //                     AppConstants.flame_loader,
          //                     width: 150,
          //                     height: 150,
          //                     fit: BoxFit.fill,
          //                     frameRate: FrameRate(60),
          //                   ),
          //                 ),
          //               Transform.translate(
          //                 offset: Offset(
          //                   0,
          //                   (controller.value * 100).clamp(0.0, 100.0),
          //                 ),
          //                 child: child,
          //               ),
          //             ],
          //           );
          //         },
          //         durations: RefreshIndicatorDurations(
          //           completeDuration: Duration(seconds: 2),
          //         ),
          //         child: _buildBody(context),
          //       )
          //     :
          _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        controller: widget.scrollController ?? null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [...widget.children]
              // .animate(autoPlay: true, interval: 150.ms)
              // .fade(duration: 300.ms),
              ),
        ),
      ),
    );
  }
}
