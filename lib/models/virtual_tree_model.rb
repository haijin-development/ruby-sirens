require 'observer'

module Sirens
    class VirtualTreeModel
        include Observable

        class << self
            def with(root_item)
                self.on([root_item])
            end

            def with_all(root_items)
                self.on(root_items.clone)
            end

            def on(root_items)
                self.new(root_items)
            end
        end

        # Initializing

        def initialize(roots: [], get_children_block:)
            super()

            @get_children_block = get_children_block

            @roots = roots.collect{ |item| new_tree_node_on(item) }
        end

        def new_tree_node_on(item)
            TreeNode.new(value: item, get_children_block: @get_children_block)
        end

        # Accessing

        def roots()
            @roots.collect{ |node| node.value }
        end

        def set_roots(new_roots)
            old_roots = roots

            @roots = new_roots.collect{ |item| new_tree_node_on(item) }

            changed

            notify_observers(
                TreeChanged.new(new_roots: new_roots, old_roots: old_roots)
            )
        end

        def node_at(path:)
            node = @roots[path.first]

            path[1..-1].each do |child_index|
                node = node.child_at(index: child_index)
            end

            node
        end

        def item_at(path:)
            node_at(path: path).value
        end

        def children_at(path:)
            node_at(path: path).children.collect{ |node| node.value }
        end

        ##
        # Given a hierarchy of objects in the tree, returns an array with the path indices.
        #
        def path_of(objects_hierarchy)
            objects = @roots

            objects_hierarchy.inject([]) { |path, each_object|
                index = objects.index { |node| node.value == each_object }

                path << index

                objects = objects[index].children

                path
            }
        end

        ##
        # Given a path returns an array with the objects on each tree level corresponding to each index in the path.
        #
        def objects_hierarchy_at(path:)
            return [] if path.nil?

            nodes = @roots

            path.inject([]) { |hierarchy, index|
                node = nodes[index]

                hierarchy << node.value

                nodes = node.children

                hierarchy
            }
        end

        # Announcements

        class TreeChanged
            def initialize(new_roots:, old_roots:)
                @new_roots = new_roots
                @old_roots = old_roots
            end

            attr_reader :new_roots, :old_roots
        end

        # Tree node class

        class TreeNode
            def initialize(value:, get_children_block:)
                @value = value
                @children = nil
                @get_children_block = get_children_block
            end

            def value()
                @value
            end

            def children()
                if @children.nil?
                    @children = get_children.collect{ |item|
                        self.class.new(value: item, get_children_block: @get_children_block)
                    }
                end

                @children
            end

            def child_at(index:)
                children[index]
            end

            def get_children()
                @get_children_block.call(value)
            end
        end
    end
end