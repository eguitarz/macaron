require 'timeout'
require 'observer'
require 'watir-webdriver'

module Macaron
  class Spawner
    def initialize(url, options)
      @options = options

      # threadpool(init workers, max workers, job timeout)
      threadpool = Threadpool.new(10, 10, job_timeout)

      # tasks saves the on-processing urls
      @tasks = Queue.new
      @tasks << url

      # parsed_urls used to prevent loop crawling
      @parsed_urls = [url]

      # awaiting_counter saves the awaiting task number
      @awaiting_counter = 1

      # bot is a webdriver
      bot = Watir::Browser.new if @options[:with_watir]

      loop do
        print "@awaiting_counter = #{@awaiting_counter}\n"
        break if @awaiting_counter == 0

        begin
          Timeout::timeout(task_timeout) { url = @tasks.shift }
        rescue
          next
        end


        job = Macaron::Crawler.new(url, bot)
        job.add_observer(self)

        threadpool.load(job)
      end

      bot.close unless bot.nil?
    end

    def update(links)
      @awaiting_counter -= 1
      links.each do |link|
        unless @parsed_urls.include?(link)
          @tasks << link
          @awaiting_counter += 1
        end
        @parsed_urls << link
      end
    end

    private 
    def task_timeout
      # webdriver is slow, it takes more time to wait the result.
      if @options[:with_watir]
        10
      else
        2
      end
    end

    def job_timeout
      if @options[:with_watir]
        20
      else
        10
      end
    end

  end
end