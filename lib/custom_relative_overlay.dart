import 'package:flutter/material.dart';

///
class CustomRelativeOverlay extends StatefulWidget {
  ///
  const CustomRelativeOverlay({
    super.key,
    required this.overlayChild,
    required this.child,
    this.leftOverlayPadding = 0,
    this.topOverlayPadding = 0,
    required this.isEnabled,
  });

  ///
  final Widget Function(OverlayPortalController) overlayChild;

  ///
  final Widget child;

  ///
  final double topOverlayPadding;

  ///
  final double leftOverlayPadding;

  ///
  final bool isEnabled;

  @override
  State<CustomRelativeOverlay> createState() => _CustomRelativeOverlayState();
}

class _CustomRelativeOverlayState extends State<CustomRelativeOverlay> {
  final OverlayPortalController _dropDownController = OverlayPortalController();

  final GlobalKey _globalKey = GlobalKey();

  Offset? currentPosition;

  getPosition() {
    _dropDownController.toggle();
    if (_globalKey.currentContext != null && currentPosition == null) {
      RenderBox renderBox =
          _globalKey.currentContext!.findRenderObject() as RenderBox;
      var newPosition = renderBox.localToGlobal(Offset.zero);
      var pageHeight = MediaQuery.of(context).size.height - kToolbarHeight;

      var checkPoint = newPosition.dy + widget.topOverlayPadding + 320;
      if (checkPoint >= pageHeight) {
        currentPosition = Offset(
            newPosition.dx, newPosition.dy - (320 + widget.topOverlayPadding));
      } else {
        currentPosition = newPosition;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _globalKey,
      onTap: widget.isEnabled ? getPosition : null,
      child: OverlayPortal(
        controller: _dropDownController,
        overlayChildBuilder: (context) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _dropDownController.hide();
                },
                child: Container(
                  color: Colors.black26,
                ),
              ),
              Positioned(
                left: (currentPosition?.dx ?? 0) + widget.leftOverlayPadding,
                top: (currentPosition?.dy ?? 0) + widget.topOverlayPadding,
                child: widget.overlayChild(_dropDownController),
              ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
