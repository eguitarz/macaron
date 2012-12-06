require 'rubygems'
require 'threadpool'

module Macaron
  class Processor < Job
    @@output_lock = Mutex.new
    
    def run
      begin
        url = @args.shift
        depth = @args.shift
        html = @args.shift
        return if depth <= 0
        scraper = Scraper.new
        scraper.analyze(url, html)

        # @@result[url] = {:anchors => scraper.anchors}
        @@result[url] = true;

        # do some additional analyzes
        run_sub_tasks(scraper)

        links = nil
        if @@options[:in_site_crawling]
          links = scraper.internal_anchors
        else
          links = scraper.absolute_anchors
        end
        puts "found #{links.size} links on #{url}" if @@options[:debug]

        links.each { |a|
          next if @@parsed_urls.include?(a)
          p "put #{a} into tasks" if @@options[:debug]
          @@task_map = @@task_map.put(a, depth - 1)
        }

        @@mutex.synchronize {
          @@success_times += 1
        }
      rescue Exception => e
        @@mutex.synchronize {
          @@fail_times += 1
        }
        print "Error on job: #{url}, msg: #{e.message}\n"
      end
    end

    private
    def run_sub_tasks(scraper)
      # p scraper.image_urls
      
      if @@options[:save]
        dir = @@options[:dir] || '/tmp'
        filename = scraper.host.gsub('/', '\\')
        File.open(File.join(dir, filename), "w+") do |f|
          f.write(scraper.dom)
        end
      end
    end

  end
end