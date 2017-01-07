class BooksController < Shikigami::BaseController
  private
  def collection_scope
    Book
  end
end
