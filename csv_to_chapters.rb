#!/usr/bin/env ruby
require 'rubygems'

require File.dirname(__FILE__) + "/" + "blog_entries.rb"
require File.dirname(__FILE__) + "/" + "blog_entry.rb"

class IndexEntry
  def self.from_csv_file(path, delimeter = "\t")
    File.new(path).read.split("\n").map{|line| IndexEntry.new(line)}
  end

  def initialize(line)
    @cols = line.split("\t")
  end
  
  def category
    @cols[3]
  end
  
  def id
    @cols[0].to_i
  end
end

editing_dir = "editing"
index_file_path = File.dirname(__FILE__) + "/#{editing_dir}/index.csv"
index_entries = IndexEntry.from_csv_file index_file_path

src_dir = "TransparentThoughts"
blog_entries = BlogEntries.new(src_dir).entries

blog_entry_groups = []
index_entries.each do |index_entry|
  p "grouping blog entry: ##{index_entry.id}"
  group_id = index_entry.category.to_i
  blog_entry_groups[group_id] ||= []
  blog_entry_groups[group_id] << blog_entries.find{|blog_entry| blog_entry.id == index_entry.id}
end

require 'utils'

dist_dir = "#{editing_dir}/chapters"
rm_rf dist_dir
mkdir dist_dir

blog_entry_groups.each do |entries|
  wash_to_html("#{dist_dir}/chapter_#{blog_entry_groups.index(entries)}.html") do |body|
    entries.each do |entry|
      body << entry.to_div
    end
  end
end
