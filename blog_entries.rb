require 'builder'

class BlogEntries
  require 'fileutils'
  include FileUtils

  def initialize(src_dir_path)
    src_dir = Dir.new(absolute_path(src_dir_path))
    file_names = src_dir.entries.reject{|entry|entry.index(".")==0}
    blog_file_names = file_names.reject{|entry|entry.include?("index")}
    @entries = blog_file_names.map{|entry|BlogEntry.new(absolute_path(src_dir_path + "/" + entry))}
    @entries.sort!{|a, b|a.id <=> b.id}
  end
  
  def to_html
    wash_to_html do |body|
      @entries.each do |entry|
        body << entry.to_div
      end
    end
  end
  
  def to_calc
    wash_to_html("book_calc.html") do |body|
      body.p("edit here...")
      body.table do |table|
        table << "<COL WIDTH=44><COL WIDTH=387><COL WIDTH=269><COL WIDTH=108>"
        @entries.each do |entry|
          table << entry.to_tr
        end
      end
    end
  end
  
  private
  def wash_to_html(dest = "book.html")
    dest_path = absolute_path(dest)
    rm_rf dest_path
    builder = Builder::XmlMarkup.new
    xml = builder.html do |html|
      html.head do |head|
        head.meta "HTTP-EQUIV" => "CONTENT-TYPE", "CONTENT" => "text/html; charset=gb2312"
      end
      html.body do |body|
        yield body
      end
    end
    File.open(dest_path, "w"){|file|file.write xml}
  end
  
  def absolute_path(path)
    File.dirname(__FILE__) + "/" + path
  end
end
