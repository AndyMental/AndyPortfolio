class AddNotNullToBlogs < ActiveRecord::Migration[7.0]
  # Reference: [AND-5289](mention://issue/38e1d71b-4828-417f-a9dc-198b17786c28)
  def change
    change_column_null :blogs, :title, false
    change_column_null :blogs, :body, false
  end
end
