module Sirens
    class Method
        # Initializing

        def initialize(mod:, name:, visibility:, instance_method:)
            @mod = mod
            @name = name
            @visibility = visibility
            @is_instance_method = instance_method

            @method_filename, @method_line_number = to_ruby_method.source_location

            @source_code = nil

        end

        # Accessing

        attr_reader :mod,
            :name,
            :visibility,
            :is_instance_method,
            :method_filename,
            :method_line_number

        # Asking

        def is_public?()
            visibility == :public
        end

        def is_protected?()
            visibility == :protected
        end

        def is_private?()
            visibility == :private
        end

        def is_instance_method?()
            is_instance_method
        end

        # Querying

        def icon()
            filename = 'public-method.png'
            
            Pathname.new(__FILE__).dirname + '../../../resources/icons/' + filename             
        end

        def source_location()
            "#{method_filename}:#{method_line_number}"
        end

        def source_code()
            if @source_code.nil?
                method = to_ruby_method

                @source_code ||= remove_indentation(method.comment) + "\n" + remove_indentation(method.source)
            end
        
            @source_code
        end

        # Converting

       def to_ruby_method()
            is_instance_method? ? @mod.instance_method(@name) : @mod.method(@name)
        end

        # Utility methods

        def remove_indentation(source_code)
            lines = source_code.lines

            indentation = 0

            /^(\s*).*$/.match(lines.first) do |matches|
                indentation = matches[1].size
            end

            lines = lines.collect { |line|
                line.gsub!(/^\s{#{indentation}}/, '')
            }

            lines.join
        end
    end
end