require 'rubygems'
require 'observer'
require 'timeout'
require 'threadpool'

module Macaron
  class Crawler < Job
    include Observable

    def run
      url, bot = @args
      page = Page.new(url, bot)
      links = []
      begin
        links = page.fetch.inner_links
      rescue
      end
      changed
      notify_observers(links)
      print "#{url} >> #{page.title}\n"
      delete_observers
    end
  end
end