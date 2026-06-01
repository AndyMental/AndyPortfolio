json.extract! blog, :id, :title, :body, :tags, :tag_list, :created_at, :updated_at
json.url blog_url(blog, format: :json)
