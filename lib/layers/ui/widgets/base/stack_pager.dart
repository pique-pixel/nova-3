import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';

enum PanelState { open, closed }

class _StackPageData {
  final int id;
  final bool isVisible;
  final Color color;
  final Widget header;
  final Widget body;

  _StackPageData({
    @required this.id,
    @required this.color,
    this.isVisible = true,
    @required this.header,
    @required this.body,
  });

  _StackPageData copyWith({
    int id,
    Color color,
    bool isVisible,
    Widget header,
    Widget body,
  }) {
    return _StackPageData(
      id: id ?? this.id,
      color: color ?? this.color,
      isVisible: isVisible ?? this.isVisible,
      header: header ?? this.header,
      body: body ?? this.body,
    );
  }

  @override
  String toString() => '$_StackPageData(id: $id, isVisible: $isVisible)';
}

class StackPager extends StatefulWidget {
  final double headerSize;
  final double gap;
  final List<StackPage> pages;
  final Widget backgroundContent;

  const StackPager({
    Key key,
    @required this.headerSize,
    @required this.pages,
    this.gap = 24,
    this.backgroundContent,
  }) : super(key: key);

  @override
  _StackPagerState createState() => _StackPagerState();
}

class _StackPagerState extends State<StackPager> {
  double _fadeOpacity = 0.0;
  final _stacks = <_StackPageData>[];

  @override
  void initState() {
    super.initState();

    widget.pages.asMap().forEach(
          (index, it) => _stacks.add(
            _StackPageData(
              id: index,
              color: it.color,
              header: it.header,
              body: it.body,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    children.add(
      Positioned.fill(
        child: Container(
          color: AppColors.white,
          child: widget.backgroundContent,
        ),
      ),
    );

    children.add(
      Positioned.fill(
        child: IgnorePointer(
          child: AnimatedOpacity(
            opacity: _fadeOpacity,
            duration: const Duration(milliseconds: 300),
            child: Container(color: Colors.black),
          ),
        ),
      ),
    );

    children.addAll(_createStack(context));

    return Stack(children: children);
  }

  List<Widget> _createStack(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final widgets = <Widget>[];
    final maxHeight = mediaQuery.size.height - mediaQuery.padding.top;

    _stacks.asMap().forEach(
          (index, value) => widgets.add(
            _StackPage(
              headerSize: widget.headerSize,
              header: value.header,
              body: value.body,
              isVisible: value.isVisible,
              color: value.color,
              minHeight:
                  maxHeight / 3 + (_stacks.length - index) * widget.headerSize,
              maxHeight: maxHeight - widget.gap,
              onToggle: (isOpen) {
                if (isOpen) {
                  _fadeOpacity = 0.5;
                } else {
                  _fadeOpacity = 0;
                }
                setState(() {
                  final newStacks = _stacks
                      .map(
                        (it) => it.id != value.id
                            ? it.copyWith(isVisible: !isOpen)
                            : it,
                      )
                      .toList();

                  _stacks.clear();
                  _stacks.addAll(newStacks);
                });
              },
            ),
          ),
        );

    return widgets;
  }
}

class StackPage {
  final Color color;
  final Widget header;
  final Widget body;

  const StackPage({
    @required this.color,
    @required this.header,
    @required this.body,
  });
}

class _StackPage extends StatefulWidget {
  final Color color;
  final PanelState defaultPanelState;
  final double minHeight;
  final double maxHeight;
  final bool isVisible;
  final void Function(bool isOpen) onToggle;
  final Widget header;
  final Widget body;
  final double headerSize;

  const _StackPage({
    Key key,
    @required this.color,
    this.defaultPanelState = PanelState.closed,
    @required this.minHeight,
    @required this.maxHeight,
    @required this.onToggle,
    @required this.isVisible,
    @required this.header,
    @required this.headerSize,
    @required this.body,
  }) : super(key: key);

  @override
  _StackPageState createState() => _StackPageState();
}

class _StackPageState extends State<_StackPage> with TickerProviderStateMixin {
  AnimationController _ac;
  AnimationController _ac2;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.defaultPanelState == PanelState.closed ? 0.0 : 1.0,
    )..addListener(() {
        setState(() {});
      });

    _ac2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _ac.dispose();
    _ac2.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_StackPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.isVisible ? _show() : _hide();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Positioned(
      width: mediaQuery.size.width,
      bottom: -widget.minHeight * (1 - _ac2.value),
      child: GestureDetector(
        onVerticalDragUpdate: _onDrag,
        onVerticalDragEnd: _onDragEnd,
        onVerticalDragStart: _onDragStart,
        child: Container(
          height: _ac.value * (widget.maxHeight - widget.minHeight) +
              widget.minHeight,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            boxShadow: _ac.value < 0.8
                ? [
                    BoxShadow(
                      blurRadius: 32 * (1 - _ac.value),
                      color: Color.fromARGB(192, 108, 131, 166),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: widget.header,
                ),
                onTap: () {
                  _toggle();
                  widget.onToggle(_ac.value < 0.5);
                },
              ),
              Expanded(child: widget.body),
            ],
          ),
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    _isDragging = details.localPosition.dy < widget.headerSize;
  }

  void _onDrag(DragUpdateDetails details) {
    if (!_isDragging) {
      return;
    }

    _ac.value -= details.primaryDelta / (widget.maxHeight - widget.minHeight);
  }

  void _onDragEnd(DragEndDetails details) {
    if (_ac.isAnimating || !_isDragging) return;

    _isDragging = false;
    final minFlingVelocity = 365.0;

    if (details.velocity.pixelsPerSecond.dy.abs() >= minFlingVelocity) {
      double visualVelocity = -details.velocity.pixelsPerSecond.dy /
          (widget.maxHeight - widget.minHeight);
      _ac.fling(velocity: visualVelocity);
      debugPrint(visualVelocity.toString());
      widget.onToggle(visualVelocity > 0.5);
      return;
    }

    // check if the controller is already halfway there
    _ac.value > 0.5 ? _open() : _close();
    widget.onToggle(_ac.value > 0.5);
  }

  _close() => _ac.fling(velocity: -1.0);

  _open() => _ac.fling(velocity: 1.0);

  _hide() => _ac2.fling(velocity: -1.0);

  _show() => _ac2.fling(velocity: 1.0);

  _toggle() {
    if (_ac.isAnimating) return;
    _ac.value < 0.5 ? _open() : _close();
  }
}
