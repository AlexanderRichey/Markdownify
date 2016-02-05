#For after running jekyll-import.

class String
  def markdownify
    output = ""

    if image?(self)
      output << "***THERE WAS AN IMAGE HERE***"
    elsif paragraph?(self)
      output << italics(links(paragraphs(self)))
    elsif blockquote?(self)
      output << italics(links(paragraphs(blockquotes(self))))
    else
      output << front_matter(self)
    end

    output
  end

  private

  def paragraph?(string)
    front_matter(string) == "" && string.start_with?("<p>") ? true : false
  end

  def blockquote?(string)
    front_matter(string) == "" && string.start_with?("<blockquote>") ? true : false
  end

  def image?(string)
    n = 0
    while n < string.length - 3
      return true if string[n..(n + 3)] == "<img"
      n += 1
    end
    false
  end

  def front_matter(string)
    string.split.first == "---" || string.split.first == "layout:" || string.split.first == "title:" ? string : ""
  end

  def paragraphs(string)
    string.gsub("<p>", "").gsub("</p>", "\n")
  end

  def blockquotes(string)
    string.gsub("<blockquote>", ">").gsub("</blockquote>", "")
  end

  def italics(string)
    string.gsub(" <em>", " *").gsub("<em>", "*").gsub(" </em>", "* ").gsub("</em>", "*")
  end

  def md_link(string)
    url_start = string.index('<a href=') + 8
    url_end = string.index('>', url_start) - 1
    url = string[url_start..url_end]

    linked_text_start = url_end + 2
    linked_text_end = string.index('</a>', linked_text_start) - 1
    linked_text = string[linked_text_start..linked_text_end]

    @link_start = url_start - 8
    @link_end = linked_text_end + 4

    "[#{linked_text}](#{url})"
  end

  def links(string)
    return string unless string.include?('<a href=')

    new_link = md_link(string)
    old_link = string[@link_start..@link_end]

    new_string = string.sub(old_link, new_link)
    links(new_string)
  end
end

if $PROGRAM_NAME == __FILE__
  input_files = ARGV

  input_files.each do |input|
    post_name = input.sub(".html", ".md")
    new_file = File.open(post_name, "w")

    File.foreach(input) do |line|
      new_file.puts line.markdownify unless line.markdownify == ""
    end
  end
end
