class AddNotNullToBlogTitleAndBody < ActiveRecord::Migration[7.0]
  def up
    Blog.reset_column_information
    Blog.where(title: nil).update_all(title: "(missing title)")
    Blog.where(body: nil).update_all(body: "(missing body)")

    change_column_null :blogs, :title, false
    change_column_null :blogs, :body, false
  end

  def down
    change_column_null :blogs, :title, true
    change_column_null :blogs, :body, true
  end
end
