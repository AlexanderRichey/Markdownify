#For after running jekyll-import.

class String
  def markdownify
    output = ""

    if image?
      output << "***THERE WAS AN IMAGE HERE***"
    elsif paragraph?
      output << self.paragraphs.links.italics
    elsif blockquote?
      output << self.blockquotes.paragraphs.links.italics
    else
      output << self.front_matter
    end

    output
  end

  def paragraph?
    front_matter == "" && start_with?("<p>") ? true : false
  end

  def blockquote?
    front_matter == "" && start_with?("<blockquote>") ? true : false
  end

  def image?
    n = 0
    while n < self.length - 3
      return true if self[n..(n + 3)] == "<img"
      n += 1
    end
    false
  end

  def front_matter
    self.split.first == "---" || self.split.first == "layout:" || self.split.first == "title:" ? self : ""
  end

  def paragraphs
    gsub("<p>", "").gsub("</p>", "\n")
  end

  def blockquotes
    gsub("<blockquote>", ">").gsub("</blockquote>", "")
  end

  def italics
    gsub(" <em>", " *").gsub("<em>", "*").gsub(" </em>", "* ").gsub("</em>", "*")
  end

  def url_start
    index('<a href=') + 9
  end

  def url_end
    index('>', url_start) - 2
  end

  def url
    self[url_start..url_end]
  end

  def linked_text_start
    url_end + 3
  end

  def linked_text_end
    index('</a>', linked_text_start) - 1
  end

  def linked_text
    self[linked_text_start..linked_text_end]
  end

  def html_link
    link_start = url_start - 9
    link_end = linked_text_end + 4
    self[link_start..link_end]
  end

  def md_link
    "[#{linked_text}](#{url})"
  end

  def links
    return self unless self.include?('<a href=')

    new_string = self.sub(html_link, md_link)
    new_string.links
  end
end

if $PROGRAM_NAME == __FILE__
  ARGV.each do |input|
    post_name = input.sub(".html", ".md")
    new_file = File.open(post_name, "w")

    File.foreach(input) do |line|
      new_file.puts line.markdownify unless line.markdownify == ""
    end
  end
end
