$LOAD_PATH.unshift( File.expand_path( File.dirname(__FILE__) + '/../lib') )

require 'sirens'

class User
    # Initializing

    def initialize(name:, last_name:)
        super()

        @name = name
        @last_name = last_name
    end

    attr_accessor :name, :last_name

    # Returns the full name of the user.
    def full_name()
        name + ' ' + last_name
    end
end

user = User.new(name: 'Lisa', last_name: 'Simpson')

Sirens.browse(object: user)