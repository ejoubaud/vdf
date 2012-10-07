# encoding: utf-8

FactoryGirl.define do

  factory :document do
    sequence(:name) {|n| "doc_#{n}" }
    title       'Document'
    description <<-DOC.strip_heredoc
                  <p>Une description avec une liste :</p>
                    <ul>
                      <li>Elem 1</li>
                      <li>Elem 2</li>
                    </ul>
                DOC
    year        2010

    # full document sheet with checklist, reviews and options
    factory :document_sheet do
      ignore do
        checks_count 5
        reviews_count 3
        options_count 2
      end

      after(:create) do |sheet, eval|
        FactoryGirl.create_list(:check, eval.checks_count, document: sheet)
        FactoryGirl.create_list(:review, eval.reviews_count, document: sheet)
        FactoryGirl.create_list(:theme, eval.options_count, document: sheet)
      end
    end
  end

  factory :stamp do
    name  'false'
    title 'Faux'
  end

  factory :check do
    claim  'Le docu dit ça'
    remark "En vrai c'est pas vrai"

    document
    stamp
  end

  factory :link do
    title       "Titre"
    url         'http://link.com'
    description 'Description du lien'

    factory :document_link, :class => 'DocumentLink', aliases: [ :review ] do
      document
    end

    factory :category_link, :class => 'CategoryLink' do
      category
    end
  end

  factory :link_category, aliases: [ :category ] do
    name 'Theme'

    document

    # theme with links
    factory :option, aliases: [ :theme ] do
      ignore do
        links_count 2
      end

      after(:create) do |theme, eval|
        FactoryGirl.create_list(:category_link, eval.links_count, category: theme)
      end
    end
  end

end