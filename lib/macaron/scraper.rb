require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'benchmark'
require 'timeout'
require 'watir-webdriver'

module Macaron
  class Scraper

    def analyze(host, html)
      @host = host
      @html = html
      
      elapsed_seconds = 0
      begin
        timeout(@@options[:nokogiri_timeout_seconds]) do
          elapsed_seconds = Benchmark.realtime { fetch_dom }
        end
      rescue Timeout::Error
        print "Timeout on #{host}\n"
        @@mutex.synchronize {
          @@fail_times += 1
        }
      end

      @all_links = absolute_anchors

      print ">> elapsed #{elapsed_seconds} seconds to get '#{host}'\n"
    end

    def anchors
      @dom.css('a')
    end

    def absolute_anchors
      make_absolute_anchors(anchors)      
    end

    def internal_anchors
      root = URI.parse(@host).host
      @all_links.select {|l| URI.parse(l).host == root}
    end

    def external_anchors
      root = URI.parse(@host).host
      @all_links.select {|l| URI.parse(l).host != root}
    end

    def images
      @dom.css('img')
    end

    def image_urls
      images.map { |img| make_absolute(img['src']) }.compact
    end

    def fetch_dom
      if @@options[:with_waltir]
        @dom = Nokogiri::HTML(@html)
      else
        @dom = Nokogiri::HTML(open(@host))
      end
    end

    def make_absolute_anchors(nodes)
      nodes.map {|n| make_absolute(n['href']) }.compact
    end

    def make_absolute(href)
      begin
        URI.parse(@host).merge(URI.parse(href)).to_s
      rescue
        nil
      end
    end
  end
end