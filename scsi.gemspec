$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'scsi/version'


Gem::Specification.new do |s|
  s.name          = 'scsi'
  s.version       = SCSI::Version
  s.authors       = ['Ken']
  s.email         = ['ken@propelfuels.com']
  s.summary       = %q{SCSI: Slash Command Slack Info}
  s.description   = %q{A Ruby server for receiving Slack Slash Command and responding with Slack info.}
  s.homepage      = 'https://github.com/propelfuels/scsi'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.1'

  s.add_runtime_dependency 'kajiki', '~> 1.1'
  s.add_runtime_dependency 'sinatra', '~> 1.4'
end
