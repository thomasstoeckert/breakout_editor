import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:breakout_editor/data/level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockCounter extends StatelessWidget {
  const BlockCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: 90.0,
        height: 90.0,
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<EditorBloc, EditorState>(builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(
                  strokeWidth: 8.0,
                  value: state.levelData.levelData.length / LEVEL_CAP,
                ),
              ),
              Align(
                child: Text(
                  "${state.levelData.levelData.length}/$LEVEL_CAP",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
              )
            ],
          );
        }),
      ),
    );
  }
}
