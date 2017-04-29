Gem::Specification.new do |s|
  s.name = 'botbase-module-phrases'
  s.version = '0.1.2'
  s.summary = 'A botbase module for matching a speech keyword which then ' + 
      'triggers a general RSC job or publishes an SPS message etc.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/botbase-module-phrases.rb']
  s.add_runtime_dependency('rsc', '~> 0.2', '>=0.2.2')
  s.add_runtime_dependency('polyrex', '~> 1.1', '>=1.1.12')
  s.add_runtime_dependency('sps-pub', '~> 0.5', '>=0.5.4')
  s.add_runtime_dependency('spstrigger_execute', '~> 0.4', '>=0.4.6')
  s.signing_key = '../privatekeys/botbase-module-phrases.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/botbase-module-phrases'
end

