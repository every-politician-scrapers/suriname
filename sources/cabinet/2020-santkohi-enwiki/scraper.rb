#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    decorator WikidataIdsDecorator::Links

    def member_container
      noko.xpath("//table[.//th[contains(.,'Office')]]//tr[td]")
    end
  end

  class Member
    field :id do
      tds[1].css('a/@wikidata').first
    end

    field :name do
      tds[1].css('a').map(&:text).map(&:tidy).first
    end

    field :positionID do
    end

    field :position do
      tds[0].text.tidy
    end

    field :startDate do
      WikipediaDate.new(raw_start).to_s
    end

    field :endDate do
    end

    private

    def tds
      noko.css('td')
    end

    def raw_start
      tds[3].text.tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
