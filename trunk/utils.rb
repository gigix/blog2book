module Utils
  require 'fileutils'
  include FileUtils

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

include Utils