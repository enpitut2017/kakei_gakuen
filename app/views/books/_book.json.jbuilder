json.extract! book, :id, :item, :cost, :user_id, :created_at, :updated_at
json.url book_url(book, format: :json)
