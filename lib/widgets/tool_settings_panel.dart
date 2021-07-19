import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:breakout_editor/data/tool_settings.dart';
import 'package:breakout_editor/widgets/tool_settings_panels/paint.dart';
import 'package:breakout_editor/widgets/tool_settings_panels/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolBarSettingsPane extends StatelessWidget {
  const ToolBarSettingsPane({Key? key}) : super(key: key);

  final double _width = 350.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(builder: (context, state) {
      Widget content = Container();

      switch (state.mode) {
        case ToolMode.NO_TOOL:
          content = TBPanelContent();
          break;
        case ToolMode.PLACE:
          content = TBPanelContentPlace(
              state.toolSettings[state.mode] as PlaceToolSettings);
          break;
        case ToolMode.PAINT:
          content = TBPanelContentPaint(
              toolSettings:
                  state.toolSettings[state.mode] as PaintToolSettings);
          break;
        case ToolMode.DELETE:
          //content = _TBPanelContentDelete(state);
          break;
      }

      return Align(
          alignment: Alignment.centerRight,
          child: TranslationAnimatedWidget(
            enabled: state.showToolPanel,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            values: [
              Offset(_width, 0),
              Offset(0, 0),
            ],
            child: Container(
              width: _width,
              height: 500.0,
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
                      bottomRight: Radius.circular(0.0))),
              child: Container(
                child: AnimatedSwitcher(
                  child: content,
                  duration: const Duration(milliseconds: 100),
                ),
                margin: const EdgeInsets.all(16.0),
              ),
            ),
          ));
    });
  }
}

class TBPanelContent extends StatelessWidget {
  final String title;
  final List<Widget>? children;

  const TBPanelContent({Key? key, this.title = "No Tool", this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
        Divider(),
        if (children != null) ...children!
      ],
    );
  }
}
