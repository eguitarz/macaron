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

        @@result[url] = {:anchors => scraper.anchors}

        # do some additional analyzes
        run_sub_tasks(scraper)

        links = nil
        if @@options[:in_site_crawling]
          links = scraper.internal_anchors
        else
          links = scraper.absolute_anchors
        end

        links.each { |a| 
          next if @@parsed_urls.include?(a)
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
    end

  end
end