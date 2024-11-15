import 'package:flutter/material.dart';
import 'package:phonefield/custom_text_field.dart';
import 'package:phonefield/extentions.dart';

///
class CustomDropDownField extends StatefulWidget {
  ///
  const CustomDropDownField({
    super.key,
    required this.topOverlayPadding,
    required this.leftOverlayPadding,
    required this.isEnabled,
    required this.dataList,
    required this.onSelect,
    this.initialController,
    this.hintText,
    this.labelText,
    this.validator,
  });

  ///
  final double topOverlayPadding;

  ///
  final double leftOverlayPadding;

  ///
  final String? Function(String?)? validator;

  ///
  final bool isEnabled;

  ///
  final List<({String name, String? code})> dataList;

  ///
  final Function(({String name, String? code})) onSelect;

  ///
  final TextEditingController? initialController;

  ///
  final String? labelText;

  ///
  final String? hintText;

  @override
  State<CustomDropDownField> createState() => _CustomDropDownFieldState();
}

class _CustomDropDownFieldState extends State<CustomDropDownField> {
  final OverlayPortalController _dropDownController = OverlayPortalController();

  late TextEditingController controller;

  final GlobalKey _globalKey = GlobalKey();

  Offset? currentPosition;

  List<({String name, String? code})> filteredDataList = [];
  ({String name, String? code})? selectedCountry;

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
  void initState() {
    super.initState();
    init();
    controller = widget.initialController ?? TextEditingController();
  }

  @override
  void didUpdateWidget(covariant CustomDropDownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataList.length != widget.dataList.length) {
      init();
    }
  }

  init() {
    filteredDataList = [...widget.dataList];
    if (mounted) setState(() {});
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
                  FocusScope.of(context).unfocus();
                  _dropDownController.hide();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              Positioned(
                left: (currentPosition?.dx ?? 0) + widget.leftOverlayPadding,
                top: (currentPosition?.dy ?? 0) + widget.topOverlayPadding,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffCBD5E1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(
                    maxHeight: filteredDataList.isNotEmpty
                        ? MediaQuery.sizeOf(context).height * .4
                        : 12,
                  ),
                  width: 250,
                  child: ListView.builder(
                    itemCount: filteredDataList.length,
                    itemBuilder: (ctx, index) {
                      final data = filteredDataList[index];
                      return ListTile(
                        onTap: () {
                          controller.text = data.name;
                          FocusScope.of(context).unfocus();
                          _dropDownController.hide();
                          widget.onSelect.call(data);
                        },
                        leading: data.code != null
                            ? Text(
                                data.code!.emoji,
                                style: const TextStyle(
                                  fontSize: 32,
                                ),
                              )
                            : null,
                        title: Text(data.name),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
        child: CustomTextField(
          readOnly: !widget.isEnabled,
          controller: controller,
          labelText: widget.labelText,
          hintText: widget.hintText,
          validator: widget.validator,
          onChanged: (p0) {
            filteredDataList = widget.dataList.where((e) {
              return e.name.toLowerCase().startsWith(p0.toLowerCase());
            }).toList();
            setState(() {});
          },
          onTap: getPosition,
        ),
      ),
    );
  }
}
