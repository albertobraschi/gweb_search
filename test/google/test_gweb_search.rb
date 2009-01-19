# -*- mode:ruby; coding:utf-8 -*-

require 'test/unit.rb'
require File.expand_path(File.dirname(__FILE__) + '/../../lib/google/gweb_search')
require 'pit'
require 'uri'
require 'logger'

class TestGwebSearch < Test::Unit::TestCase
  def setup
    pit = Pit.get('google.com', :require => { 'key' => 'Your google API key' })
    Google::GwebSearch.options[:key] = pit['key']
    Google::GwebSearch.logger = Logger.new(STDOUT)
  end

  def test_search
    res = Google::GwebSearch.search('Squarepusher Hardcore Obelisk site:amazon.co.jp')
    assert_kind_of Google::GwebSearch::Response, res
    pr = res.parsed_response
    assert_kind_of Hash, pr
    assert_kind_of Enumerable, res.results
    assert ! res.results.empty?
    res.results.each do |r|
      uri = URI.parse(r['unescapedUrl'])
      assert_match /(?:\w+\.)?amazon.co.jp/, uri.host
    end
  end
end

class TestNullLogger < Test::Unit::TestCase
  def test_nulllogger
    logger = Google::GwebSearch::NullLogger.new
    assert_nil logger.fatal 'nop'
    assert_nil logger.error 'nop'
    assert_nil logger.warn 'nop'
    assert_nil logger.info 'nop'
    assert_nil logger.debug 'nop'
  end
end
