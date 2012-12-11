require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'thread'

module Macaron
  class Page
    def initialize(url, bot=nil)
      @url = url
      @bot = bot
      @@bot_lock = Mutex.new
    end

    def fetch
      document
      base(@url)
      self
    end

    def inner_links
      anchors = links.select {|link| 
        URI.parse(link).host == @base.host 
      }.compact
    end

    def title
      @doc.title
    end

    private
    def document
      @doc ||= Nokogiri::HTML(content)
    end

    def base(href)
      base = @doc.css('base')
      header_base_url = base.attr('href').text unless base.empty?
      base_url = header_base_url || @url
      @base ||= URI.parse(base_url)
    end

    def content
      if @bot
        # only activate one browser, needs to be thread safe.
        @@bot_lock.synchronize { 
          @bot.goto(@url)
          @bot.html
        }
      else
        open(@url)
      end
    end

    def links
      @doc.css('a').map {|a| 
        href = a['href']
        if href.start_with? 'http'
          href
        else
          make_absolute(href)
        end
      }.compact
    end    

    def make_absolute(href)
      begin
        @base.merge(URI.parse(href)).to_s
      rescue
        nil
      end
    end

  end
end