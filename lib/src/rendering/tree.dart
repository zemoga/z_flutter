part of z.flutter.rendering;

class TreeNode<T> {
  final T element;
  final List<TreeNode<T>> children = [];
  bool isSelected = false;

  TreeNode(this.element);

  factory TreeNode.flatHierarchy(
    T refElement,
    List<T> flatHierarchy,
    bool Function(T ref, T other) areRelated,
    bool Function(T element) selected,
  ) {
    final node = TreeNode(refElement);

    node.children.addAll(
      flatHierarchy.where((element) => areRelated(refElement, element)).map(
            (element) => TreeNode.flatHierarchy(
              element,
              flatHierarchy,
              areRelated,
              selected,
            ),
          ),
    );
    node.isSelected = selected(refElement);

    return node;
  }

  bool get isLeaf => children.isEmpty;
}
