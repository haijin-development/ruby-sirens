require 'stringio'

module Sirens
    class MethodModel

        # Initializing

        def initialize()
            super()

            @method_name = ValueModel.new
            @location = ValueModel.new
            @source_code = ValueModel.new
        end

        attr_reader :method_name,
            :location,
            :source_code

        def set_method(method)
            if method.nil?
                method_name.set_value(nil)
                location.set_value(nil)
                source_code.set_value(nil)

                return
            end

            method_name.set_value(method.name)

            method_filename, method_line_number = method.source_location

            location.set_value("#{method_filename}:#{method_line_number}")

            source_code.set_value(
                get_source_code_of(method: method, filename: method_filename, line_number: method_line_number)
            )
        end

        def get_source_code_of(method:, filename:, line_number:)
            return 'Native method' if filename.nil? || ! File.exists?(filename)

            source_code = StringIO.new

            lines = File.read(filename).lines

            method_comment = ''
            comment_line = line_number - 1
            while line_number >= 0
                line = lines[comment_line - 1]

                break if ! /^\s*#/.match(line)

                method_comment = line + method_comment

                comment_line -= 1
            end

            source_code.write(method_comment)

            tail = lines[line_number -1 .. -1].join

            stream = StringIO.new(tail)

            counter = 0

            keywords = ['module', 'class', 'def', 'if', 'while', 'do', 'begin']

            while !stream.eof?

                while !stream.eof? && (c = stream.getc) == ' '
                    source_code.write(' ')
                end

                stream.ungetc(c)

                token = stream.gets(' ')

                source_code.write(token)

                token = token.strip

                if token == 'end'
                    counter -= 1
                elsif keywords.include?(token)
                    counter += 1
                end

                break if counter == 0
            end

            fix_indentation(source_code.string)
        end

        def fix_indentation(source_code)
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