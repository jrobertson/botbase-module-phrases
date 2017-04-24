# Using the botbase-module-phrases gem for a executing command from a matching phrase

    require 'botbase-module-phrases.rb'

    keywords = '/home/james/jamesrobertson.eu/qbx/r/speech_keywords.txt'

    bmp = BotBaseModulePhrases.new keywords: keywords, host: 'rse', 
        package_src: 'http://a0.jamesrobertson.eu/qbx/r/dandelion_a3'
    r = bmp.query 'are you winning?'

## Resources

* botbase-module-phrases https://rubygems.org/gems/botbase-module-phrases

voice assistant botbase module phrases
