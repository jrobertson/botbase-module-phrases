#!/usr/bin/env ruby

# file: botbase-module-phrases.rb

# A service module used by the BotBase gem


require 'rsc'
require 'polyrex' 
require 'sps-pub'
require 'spstrigger_execute'


class BotBaseModulePhrases
  
  def initialize(host: nil, reg: nil, keywords: '', 
              px_url: nil, voiceassistant: 'emma', callback: nil)

    @rsc = RSC.new host
    
    # px may be use in future for advanced rules which use conditionals
    #px = Polyrex.new px_url
    
    @keywords, @voiceassistant, @bot = keywords, voiceassistant, callback
    botlog = @bot.log ? @bot.log : nil

    @ste = SPSTriggerExecute.new keywords, reg=nil, px=nil, log: botlog

  end
  
  def query(sender='user01', said, mode: :voicechat, echo_node: 'node1')    
        
    #puts 'inside phrases::query()' + said.inspect
    
    a = @ste.mae message: said

    if a.length > 0 then
      
      h = {
      
        rse: ->(x, rsc){
        
          job = x.shift[/\/\/job:(.*)/,1]                  
          package_path = x.shift 
          package = package_path[/([^\/]+)\.rsf$/,1]
          
          rsc.run_job package, job, {}, args=x, package_path: package_path
        }, 
        rse_uri: ->(x, rsc){
        
          Rse.call x          
          
        },         
        sps: ->(x, rsc){
                        
          topic, msg = x.split(':',2)
                        
          fqm = (topic == 'reply' and mode == :voicechat) ? 
                       echo_node + "/echo/#{@voiceassistant}: " + msg : x

          @bot.notice fqm
       },
        ste: ->(x, rsc){ @ste.run x }
      }

    end
            
    
    r = nil
            
    a2 = a.map do |type, x| 
      
        
      if @bot.log then
        
        instruction = x.length > 60 ? x[0..57] + '...' : x
        @bot.log.info "BotBaseModulePhrases/query: matched type: %," + 
            " instruction: %s in response to %s" % [type, instruction, said]
        
      end
      
      begin
        r = h[type].call x, @rsc
      rescue

        if @bot.log then
          @bot.log.debug 'BotBaseModulePhrases/query/error: ' + ($!).inspect
        end

      end
      
      
      if type == :sps and x[/^reply/] and mode != :voicechat then

        r = x[/:\s*(.*)/,1].to_s
        
      else
        
        r

      end
      
    end # /each           
    
    return a2.join(' ')      
    
  end
  
end
