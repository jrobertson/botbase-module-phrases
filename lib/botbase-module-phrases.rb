#!/usr/bin/env ruby

# file: botbase-module-phrases.rb

# A service module used by the BotBase gem


require 'rsc'
require 'polyrex' 
require 'sps-pub'
require 'spstrigger_execute'


class BotBaseModulePhrases
  
  def initialize(host: nil, package_src: nil, reg: nil, keywords: '', 
                 px_url: nil, sps_host: 'sps', sps_port: '59000', logfile: nil)

    @rsc = RSC.new host, package_src
     
    #px = Polyrex.new px_url

    @ste = SPSTriggerExecute.new keywords, reg=nil, px=nil, logfile: logfile
    @keywords = keywords
    @sps = SPSPub.new host: sps_host, port: sps_port

  end
  
  def query(sender='user01', said, mode: :voicechat)    
        
    puts 'inside phrases::query()' + said.inspect
    
    a = @ste.mae message: said

    if a.length > 0 then
      
      h = {
      
        rse: ->(x, rsc){
        
          job = x.shift[/\/\/job:(.*)/,1]                  
          package_path = x.shift 
          package = package_path[/([^\/]+)\.rsf$/,1]
          
          rsc.run_job package, job, {}, args=x, package_path: package_path
        }, 
        sps: ->(x, rsc){ @sps.notice x },
        ste: ->(x, rsc){ @ste.run x }
      }

    end
            
    a.each do |type, x| 
      
      Thread.new do
        
        begin
          h[type].call x, @rsc
        rescue
          warning =  'botbase-module-phrases warning: ' + ($!).inspect
          puts warning
        end
        
      end # /thread
      
    end # /each           
    
  end
  
end