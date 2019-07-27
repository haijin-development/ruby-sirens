module Sirens
    class Method
        # Initializing

        def initialize(mod:, name:, visibility:, instance_method:)
            @mod = mod
            @name = name
            @visibility = visibility
            @is_instance_method = instance_method

            @ruby_method =  @is_instance_method === true ? 
                @mod.instance_method(@name) : @mod.method(@name)

            @method_filename, @method_line_number = @ruby_method.source_location

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
            if is_public?
                filename = 'public-method.png'
            elsif is_protected?
                filename = 'protected-method.png'
            elsif is_private?
                filename = 'private-method.png'
            else
                raise RuntimeError.new('Uknown visibility type.')
            end

            Pathname.new(__FILE__).dirname + '../../../resources/icons/' + filename             
        end

        def source_location()
            "#{method_filename}:#{method_line_number}"
        end

        def source_code()
            begin
                @source_code ||= remove_indentation(@ruby_method.comment) +
                    "\n" +
                    remove_indentation(@ruby_method.source)                
            rescue ::MethodSource::SourceNotFoundError => e
                @source_code = "Could not locate source for #{@mod}::#{@name}"
            end
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