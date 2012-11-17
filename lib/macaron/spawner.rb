require 'rubygems'
require 'threadpool'
require 'hamster'

module Macaron
  @@result = {}
  @@parsed_urls = Hamster.set
  @@task_map = Hamster.hash
  @@options = {}
  @@success_times = 0
  @@fail_times = 0
  @@mutex = Mutex.new

  class Spawner
    DEFALUT_OPTIONS = {
      :nokogiri_timeout_seconds => 30,
      :thread_timeout_seconds => 40,
      :pages => 1000,
      :initial_workers => 1,
      :maximum_workers => 1,
      :in_site_crawling => true,
      :with_waltir => false
    }.freeze

    def initialize(options = {})
      @@options = DEFALUT_OPTIONS.merge(options)
      @threadpool = Threadpool.new(
        @@options[:initial_workers], 
        @@options[:maximum_workers], 
        @@options[:thread_timeout_seconds]
      )
    end

    def success_times
      @@success_times
    end

    def fail_times
      @@fail_times
    end

    def dig(url, init_depth=3)
      @@task_map = @@task_map.put(url, init_depth)
      loop do
        @@task_map = @@task_map.remove {|url, depth| 
          @@parsed_urls = @@parsed_urls.add(url)

          if @@options[:with_waltir]
            html = get_html_via_waltir(url)
            @threadpool.load(Processor.new(url, depth, html))  
          else
            @threadpool.load(Processor.new(url, depth))
          end          
        }

        break if @threadpool.busy_workers_count == 0 && @@task_map.empty?

        if @@success_times > @@options[:pages]
          print "Fetched pages exceeds the limit #{@@options[:pages]}\n"
          break
        end
      end

      @bot.close unless @bot.nil?

      puts "result: #{@@result.size}, #{@@result.keys}" if @@options[:debug]
    end

    private
    def get_html_via_waltir(url)
      @bot ||= Watir::Browser.new
      @bot.goto(url)
      @bot.html
    end

  end
end