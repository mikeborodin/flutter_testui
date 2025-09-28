import 'package:consola/consola.dart';
import 'package:nocterm/nocterm.dart';

class Tree extends StatefulComponent {
  final TreeNode data;
  final ScrollController controller;
  final Function(TreeNode node)? onSelected;

  Tree({super.key, required this.data, required this.controller, this.onSelected});

  @override
  State<StatefulComponent> createState() {
    return _TreeState();
  }
}

class _TreeState extends State<Tree> {
  int position = 0;

  @override
  void initState() {
    position = 0;
    super.initState();
  }

  @override
  Component build(BuildContext context) {
    // final children = component.data.children.map((c) => c.child).toList();
    final height = Console.getWindowHeight();

    return Focusable(
      focused: true,
      onKeyEvent: (event) {
        setState(() {
          if (event.character == 'g') {
            position = 1;
            component.controller.scrollToStart();
          }
          if (event.character == 'G') {
            position = component.data.height(expandedOnly: true) - 2;
            component.controller.scrollToEnd();
          }
          if (event.character == 'i') {
            if (selectedData?.children.isNotEmpty == true) {
              selectedData?.expanded = true;
            }
          }
          if (event.character == 'n') {
            if (selectedData?.children.isNotEmpty == true) {
              selectedData?.expanded = false;
            }
          }
          if (event.character == 'u') {
            if (position > 0) {
              position--;
              if (position == component.controller.offset - 1) {
                component.controller.scrollUp();
              }
            }
          }

          if (event.character == 'e') {
            // if (position + 1 < component.data.children.length) {
            // if (position + 1 < height) {
            position++;
            if (position >= height - 10) {
              component.controller.scrollDown();
            }
            // }
          }
        });

        return false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Color.fromRGB(22, 52, 12),
            child: Text(
              [
                'ScrollController offset: ${component.controller.offset.toString()}',
                'Position: $position',
                'Tree Height: ${component.data.height(expandedOnly: true)}',
                selectedData?.children.length,
                selectedData?.expanded,
              ].join(' '),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: component.controller,
              child: Container(
                color: Colors.black,
                child: buildChildren(component.data, 0, 0, 0, NodeId(line: 0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Component buildChildren(TreeNode data, int offset, int depth, int line, NodeId state) {
    if (depth == 100) return Text('Error: the tree is too deep.');

    bool selected() {
      final result = line == position;
      if (result) {
        selectedData = data;
        // component.onSelected?.call(data);
      }
      return result;
    }

    final isSelected = selected();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Focusable(
          focused: isSelected,
          onKeyEvent: (event) {
            if (event.logicalKey == LogicalKey.enter) {
              component.onSelected?.call(data);
              return true;
            }

            return false;
          },
          child: Container(
            padding: EdgeInsets.only(left: depth.toDouble()),
            color: isSelected ? Color.fromRGB(22, 52, 42) : null,
            child: Row(
              children: [
                if (data.children.isNotEmpty)
                  Text(data.expanded ? '  ' : '  ', style: TextStyle(color: Colors.cyan))
                else
                  Text('    '),
                Expanded(child: data.child),
                Text('expanded: ${data.expanded}'),
              ],
            ),
          ),
        ),
        if (data.expanded)
          for (int i = 0; i < data.children.length; i++)
            buildChildren(data.children[i], offset + i, depth + 1, state.line++, state),
      ],
    );
  }

  TreeNode? selectedData;
}

class NodeId {
  int line;

  NodeId({required this.line});
}

class TreeNode {
  final Component child;
  final List<TreeNode> children;
  bool expanded;

  int height({required bool expandedOnly}) {
    if (children.isEmpty) return 1;

    if (!expanded && expandedOnly) return 1;

    return 1 + children.map((c) => c.height(expandedOnly: expandedOnly)).reduce((a, b) => a + b);
  }

  TreeNode({required this.child, required this.children, this.expanded = true});
}
