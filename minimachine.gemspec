$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "minimachine"

Gem::Specification.new do |s|
 s.name        = "minimachine"
 s.version     = MiniMachine::VERSION.dup
 s.authors     = ["Pedro Medeiros"]
 s.email       = ["pedrosnk@gmail.com"]
 s.homepage    = "http://github.com/pedrosnk/minimachine"
 s.summary     = "Url Shortern written in ruby"
 s.description = "short urls and put into indexes int redis database"
 s.homepage    = "http://github.com/pedrosnk/minimachine"

 s.files         = `git ls-files`.split("\n")
 s.require_paths = ["lib"]

 s.add_dependency("redis", ">~ 3.0.2")
end
