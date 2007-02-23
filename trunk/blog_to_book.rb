#!/usr/bin/env ruby
require 'rubygems'

require File.dirname(__FILE__) + "/" + "blog_entries.rb"
require File.dirname(__FILE__) + "/" + "blog_entry.rb"

src_dir = "TransparentThoughts"
src_dir = "test-src"
BlogEntries.new(src_dir).to_calc