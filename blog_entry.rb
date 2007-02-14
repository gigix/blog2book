require 'builder'
require 'hpricot'
require 'iconv'

class BlogEntry
  def initialize(file_path)
    @file_path = file_path
    p "creating blog entry : #{file_path}"
    content = File.new(file_path).read
    @doc = Hpricot.parse(content)
  end
  
  def id
    @file_path.split("/").last.split(".").first.to_i
  end

  def filename
    Iconv.conv("utf-8", "gb2312", title + ".html")
  end

  def title
    @doc.search("//div[@class='entity']/h2[@class='diaryTitle']").inner_text.gsub("- -", "")
  end
  
  def content
    @doc.search("//div[@class='entity']/p[2]").inner_html
  end
  
  def date
    @doc.search("//p[@class='diaryFoot']").inner_text.strip
  end
  
  def to_html
    p "washing blog entry: ##{id}"
    builder = Builder::XmlMarkup.new
    xml = builder.div(:id => "main") do |c|
      c.h1{|h|h << title}
      c << content
      c.div(:class => "date"){|div|div << date}
    end
    xml
  end
end