class Option < Link
  belongs_to :theme

  def to_s
    cat = theme.nil? ? "" : theme.name
    "#{cat} > #{title}"
  end
end
