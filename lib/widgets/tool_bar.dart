import 'package:breakout_editor/bloc/toolbar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToolbarBloc, ToolbarState>(
      builder: (context, state) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ToolbarButton(
                      icon: Icons.pan_tool,
                      isFocused: (state is ToolbarMove),
                      onPressed: () => context
                          .read<ToolbarBloc>()
                          .add(ToolbarMoveSelected())),
                  SizedBox(
                    width: 20,
                  ),
                  ToolbarButton(
                    icon: Icons.brush,
                    isFocused: (state is ToolbarPaint),
                    onPressed: () =>
                        context.read<ToolbarBloc>().add(ToolbarPaintSelected()),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ToolbarButton(
                    icon: Icons.add,
                    isFocused: (state is ToolbarPlace),
                    onPressed: () =>
                        context.read<ToolbarBloc>().add(ToolbarPlaceSelected()),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ToolbarButton(
                    icon: Icons.delete,
                    isFocused: (state is ToolbarDelete),
                    onPressed: () => context
                        .read<ToolbarBloc>()
                        .add(ToolbarDeleteSelected()),
                  )
                ],
              ),
            ));
      },
    );
  }
}

class ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isFocused;

  const ToolbarButton(
      {Key? key, required this.icon, required this.isFocused, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          elevation: isFocused ? 6.0 : null,
          primary: isFocused
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor),
      child: Icon(icon),
      onPressed: onPressed,
    );
  }
}
