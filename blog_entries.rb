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
    dest_path = absolute_path("book.html")
    rm_rf dest_path
    
    builder = Builder::XmlMarkup.new
    builder.instruct! :xml, :encoding => "gb2312"
    xml = builder.html do |html|
      html.head do |head|
        head.link :rel => "stylesheet", :href => "style.css", :type => "text/css"
      end
      html.body do |body|
        @entries.each do |entry|
          body << entry.to_html
        end
      end
    end
    File.open(dest_path, "w"){|file|file.write xml}
  end
  
  private
  def absolute_path(path)
    File.dirname(__FILE__) + "/" + path
  end
end