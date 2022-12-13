class Rakuten::BookSearch
  require 'open-uri'
  require 'URI'

  def initialize(*args)
    params = args.extract_options!
    @request_url = request_url(params[:title], params[:isbn])
  end

  def result
    if @request_url
      url = URI.open(@request_url).read
      items = JSON.parse(url, { symbolize_names: true })[:Items]
      if items.any?
        {status: :OK, value: JSON.parse(url, { symbolize_names: true })[:Items]}
      else
        {status: :ERR, title: "検索できません。", description: "該当するデーターはありません。" }
      end
    else
      {ststus: :ERR, title: "検索できません。", description: "最低１つの検索条件が必要です。" }
    end
  end

  private

  def application_id
    Rails.application.credentials.rakuten[:application_id]
  end 

  def request_url(title, isbn)
    if title.present? || isbn.present?
      book_search_url + paramators(title, isbn)
    end
  end

  def book_search_url
    "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?"
  end

  def paramators(title, isbn)
    {
      title: title,
      isbn: isbn,
      format: 'json',
      formatVersion: 2,
      applicationId: application_id
    }.transform_values{|v| v == "" ? v = nil : v }.compact.to_param
  end
end
