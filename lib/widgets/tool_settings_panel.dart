import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolBarSettingsPane extends StatelessWidget {
  const ToolBarSettingsPane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(builder: (context, state) {
      return Align(
          alignment: Alignment.centerRight,
          child: TranslationAnimatedWidget(
            enabled: state.showToolPanel,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            values: [
              Offset(200, 0),
              Offset(0, 0),
            ],
            child: Container(
                width: 200.0,
                height: 400.0,
                child: Container(
                  child: _TBPanelContentPlace(),
                  margin: const EdgeInsets.all(8.0),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(1.0, 2.0),
                          blurRadius: 5.0,
                          spreadRadius: 0.0)
                    ],
                    borderRadius: BorderRadius.circular(15.0).copyWith(
                        topRight: Radius.circular(0.0),
                        bottomRight: Radius.circular(0.0)))),
          ));
    });
  }
}

class _TBPanelContentPlace extends StatefulWidget {
  const _TBPanelContentPlace({Key? key}) : super(key: key);

  @override
  __TBPanelContentPlaceState createState() => __TBPanelContentPlaceState();
}

class __TBPanelContentPlaceState extends State<_TBPanelContentPlace> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text("Place Tool"),
        Divider(),
        ListTile(
          title: Text("Use Grid"),
          trailing: Switch.adaptive(value: false, onChanged: (_) => print(_)),
        ),
        ListTile(
          title: Text("Grid Size"),
          trailing: DropdownButton(
            items: [
              DropdownMenuItem(child: Text("8x20")),
              //DropdownMenuItem(child: Text("8x8"))
            ],
          ),
        )
      ],
    );
  }
}
