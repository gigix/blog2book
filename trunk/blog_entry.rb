require 'builder'
require 'hpricot'
require 'iconv'

class BlogEntry
  attr_reader :id

  def initialize(file_path)
    @file_path = file_path
    @id = @file_path.split("/").last.split(".").first.to_i
    p "creating blog entry : #{file_path}"
    content = File.new(file_path).read
    @doc = Hpricot.parse(content)
  end
  
  def filename
    Iconv.conv("utf-8", "gb2312", title + ".html")
  end

  def title
    @doc.search("//div[@class='entity']/h2[@class='diaryTitle']").inner_text.gsub("- -", "")
  end
  
  def content
    @doc.search("//div[@class='entity']/p[2]").inner_html.gsub(/<img.+>/, "(there's an image)")
  end
  
  def link
    "<a href=#{@file_path}>#{title}</a>"
  end
  
  def date
    @doc.search("//p[@class='diaryFoot']").inner_text.strip.gsub(/.+200/, "200")
  end
  
  def to_div
    p "washing blog entry: ##{id}"
    builder = Builder::XmlMarkup.new
    xml = builder.div(:id => "main") do |c|
      c.p(:style => "margin-bottom: 0in; page-break-before: always")
      c.h1{|h|h << title}
      c << content
      c.div(:class => "date"){|div|div << "#{date} (#{id})"}
    end
    xml
  end
  
  def to_tr
    p "washing blog entry to table: ##{id}"
    builder = Builder::XmlMarkup.new
    xml = builder.tr do |tr|
      tr.td(id)
      tr.td{|td| td << link}
      tr.td{|td| td << date}
      tr.td("NotSelected")
    end
    xml
  end
end
