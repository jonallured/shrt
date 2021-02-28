require 'yaml'

class PostRedirect
  include Comparable

  PREFIX = "https://www.jonallured.com/posts"

  def self.for(path)
    data = File.read(path)
    yaml = data.split('---')[1]
    front_matter = YAML.safe_load(yaml)
    post_id = front_matter["id"]
    filename = path.split("/").last

    new(filename, post_id)
  end

  attr_reader :filename, :post_id

  def initialize(filename, post_id)
    @filename = filename
    @post_id = post_id
  end

  def <=>(other)
    post_id <=> other.post_id
  end

  def to_hash
    {
      "short" => shortcut,
      "long" => long_url
    }
  end

  private

  def shortcut
    ["post", post_id].join("-")
  end

  def long_url
    year, month, day, *rest = filename.split("-")
    page = rest.join("-").gsub(/\.md$/, "")
    parts = [PREFIX, year, month, day, page]
    parts.join("/")
  end
end

