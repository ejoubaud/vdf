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
        FactoryGirl.create_list(:options_theme, eval.options_count, document: sheet)
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

    factory :review, :class => 'Review' do
      document
    end

    factory :option, :class => 'Option' do
      theme
    end
  end

  factory :theme do
    name 'Theme'

    document

    # theme with links
    factory :options_theme do
      ignore do
        links_count 2
      end

      after(:create) do |theme, eval|
        FactoryGirl.create_list(:option, eval.links_count, theme: theme)
      end
    end
  end

  factory :user do
    login                 'vdf'
    password              'vdfvdf'
    password_confirmation 'vdfvdf'
    email                 'vdf@vdf.com'
  end

end