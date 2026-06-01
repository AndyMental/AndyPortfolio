xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Andy Mental's Blog"
    xml.description "Andy Mental's portfolio — a Rails-backed blog companion to the andy-portfolio.com showcase."
    xml.link blogs_url

    @blogs.each do |blog|
      xml.item do
        xml.title blog.title
        xml.description { xml.cdata!(blog.body) }
        xml.pubDate blog.created_at.to_fs(:rfc822)
        xml.link blog_url(blog)
        xml.guid blog_url(blog)
      end
    end
  end
end
