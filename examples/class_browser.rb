$LOAD_PATH.unshift( File.expand_path( File.dirname(__FILE__) + '/../lib') )

require 'sirens'

object = Random.new

Sirens.browse(klass: object)
