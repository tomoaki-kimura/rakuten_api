class Book < ApplicationRecord
  def self.set_api(*args)
    params = args.extract_options!
    api_data = Rakuten::BookSearch.new(params).result
    if api_data[:status] == :OK
      books = api_data[:value].map do |o|
        book = Book.find_or_initialize_by(isbn: o[:isbn])
        if book.new_record?
          book.assign_attributes(
            title: o[:title],
            author: o[:author],
            item_price: o[:itemPrice],
            item_url: o[:itemUrl],
            image_url: o[:largeImageUrl]
          )
        end
        book
      end
      [:OK, books]
    else
      blank_data = Book.new
      blank_data.errors.add(api_data[:title], api_data[:description])
      [:NG, blank_data]
    end
  end
end
