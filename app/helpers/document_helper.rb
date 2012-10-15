module DocumentHelper

  SECTIONS =  [
      { id: 'id-card', title: 'ID Card' },
      { id: 'checklist', title: 'Checklist',
        :filters => {
          show: lambda { |doc| doc.checks.blank? }
        }
      },
      { id: 'reviews', title: 'Critiques',
        :filters => {
          show: lambda { |doc| doc.reviews.blank? }
        }
      },
      { id: 'options', title: 'Alternatives',
        :filters => {
          show: lambda { |doc| doc.themes.blank? }
        }
      }
    ]

  # Returns a Hash { title => section_id } for all sections  of a document
  # Can filter on some conditions that may depend on the document's state
  def nav_list filter = nil, document = nil
    SECTIONS.reduce({}) do |nav_list, section|
      nav_list[ section[:title] ] = section[:id] unless filters section, filter, document
      nav_list
    end
  end

  # Returns a Hash { letter => [doc1, doc2...] }
  # of documents sorted by their title's upcased first letter
  def hash_by_title_initial documents
    documents.reduce({}) do |by_letter, doc|
      by_letter[doc.title[0].upcase] ||= [];
      by_letter[doc.title[0].upcase] << doc;
      by_letter
    end
  end

  # Returns a Hash { key => key.downcased }
  # whose String values are keys' downcased values
  def downcase_keys hash
    hash.merge(hash) { |key, _| key.downcase }
  end

private

  # Looks for a matching filter and returns true if filter is true
  def filters section, filter, doc
    if section.key? :filters
      filters = section[:filters]
      if filters.key? filter
        filters[filter].call doc
      end
    end
  end

end
