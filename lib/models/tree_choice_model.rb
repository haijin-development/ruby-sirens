module Sirens
    class TreeChoiceModel

        # Initializing

        def initialize(selection: nil, roots: [], get_children_block:)
            super()

            @selection = ValueModel.on(selection)
            @tree = VirtualTreeModel.on(
                roots: roots,
                get_children_block: get_children_block
            )
        end

        # Accessing

        ##
        # Returns the selection model, not the selected item.
        # This model can be observed for changes.
        # This model value is an array with the objects path from the tree root object to the selected item.
        #
        def selection()
            @selection
        end

        ##
        # Sets the item currently selected.
        # The objects_hierarchy is an array with the objects path from the tree root object to the
        # selected item.
        # The selection model triggers an announcement that its value changed.
        #
        def set_selection(objects_hierarchy)
            @selection.set_value(objects_hierarchy)
        end

        ##
        # Sets the item currently selected.
        # The objects_hierarchy is an array with the objects path from the tree root object to the
        # selected item.
        # The selection model triggers an announcement that its value changed.
        #
        def set_selection_from_path(path:)
            objects_hierarchies = objects_hierarchy_at(path: path)

            set_selection(objects_hierarchies)
        end

        ##
        # Returns the tree model.
        # The tree model holds the tree items and announces changes on it.
        #
        def tree()
            @tree
        end

        ##
        # Sets the tree model roots.
        # Announces that the tree changed.
        #
        def set_tree_roots(items)
            @tree.set_roots(items)
        end

        ##
        # Returns the item in the tree at the given path.
        # The path is an array of Integers, each Integer being the index in each level of the tree.
        # Example:
        #       [1, 0, 3] returns the item taken from the second root, its first child and its fourth child.
        #
        def item_at(path:)
            @tree.item_at(path: path)
        end

        ##
        # Returns an array with the children of the item in the tree at the given path.
        #
        def children_at(path:)
            @tree.children_at(path: path)
        end

        ##
        # Given a hierarchy of objects in the tree, returns an array with the path indices.
        #
        def path_of(objects_hierarchy)
            @tree.path_of(objects_hierarchy)
        end

        ##
        # Given a path returns an array with the objects on each tree level corresponding to each index in the path.
        #
        def objects_hierarchy_at(path:)
            @tree.objects_hierarchy_at(path: path)
        end

        # Asking

        def has_selection()
            ! @selection.value.nil? && ! @selection.value.empty?
        end
    end
end