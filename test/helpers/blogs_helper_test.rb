require "test_helper"

class BlogsHelperTest < ActionView::TestCase
  test "anchor with target gains rel=noopener noreferrer" do
    out = rendered_blog_body('<a href="https://example.com" target="_blank">x</a>')

    assert_match(/<a\b[^>]*\brel="[^"]*"/, out)
    tokens = rel_tokens(out)
    assert_includes tokens, "noopener"
    assert_includes tokens, "noreferrer"
    assert_includes out, 'target="_blank"'
  end

  test "existing rel tokens are preserved and merged with safety tokens" do
    out = rendered_blog_body('<a href="https://example.com" target="_blank" rel="nofollow">x</a>')

    tokens = rel_tokens(out)
    %w[nofollow noopener noreferrer].each do |token|
      assert_includes tokens, token
    end
  end

  test "anchor without target leaves rel untouched" do
    out_plain = rendered_blog_body('<a href="https://example.com">x</a>')
    refute_match(/\brel=/, out_plain)

    out_with_rel = rendered_blog_body('<a href="https://example.com" rel="nofollow">x</a>')
    assert_equal ["nofollow"], rel_tokens(out_with_rel)
  end

  test "transformation is idempotent" do
    input = '<a href="https://example.com" target="_blank" rel="nofollow">x</a>'
    once = rendered_blog_body(input)
    twice = rendered_blog_body(once)
    assert_equal once, twice
  end

  test "disallowed tags and attributes still get stripped" do
    body = <<~HTML
      <script>alert("xss")</script>
      <p onclick="alert('xss')">Hello <strong>safe</strong></p>
      <a href="javascript:alert('xss')" target="_blank">bad</a>
      <img src=x onerror="alert('xss')">
    HTML
    out = rendered_blog_body(body)

    refute_match(/<script/i, out)
    refute_match(/onclick=/i, out)
    refute_match(/onerror=/i, out)
    refute_match(/<img\b/i, out)
    refute_match(/href="javascript:/i, out)
    assert_includes out, "<strong>safe</strong>"
  end

  private

  def rel_tokens(html)
    Nokogiri::HTML::DocumentFragment.parse(html).at_css("a")["rel"].to_s.split(/\s+/).reject(&:empty?)
  end
end
