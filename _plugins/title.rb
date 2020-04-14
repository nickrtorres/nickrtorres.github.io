# Lifted directly from http://paulherron.com/blog/custom_title_formatting_in_jekyll
#
# Use sentence case for titles
class Jekyll::Post

  def titleized_slug
    self.slug.split(/[_-]/).join(' ').capitalize
  end
end
