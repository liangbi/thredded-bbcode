# frozen_string_literal: true
require 'spec_helper'

describe Thredded::BBCode do
  it 'has a version number' do
    expect(Thredded::BBCode::VERSION).not_to be nil
  end

  it 'formats [b]' do
    bbcode = <<~'BBCODE'
      [b]hi[/b].
    BBCODE
    expected_html = <<~'HTML'.rstrip
      <p><strong>hi</strong>.</p>
    HTML
    expect(Thredded::ContentFormatter.new(nil).format_content(bbcode))
      .to(eq expected_html)
  end

  it 'formats images with bbcode and markdown' do
    bbcode = <<~'BBCODE'
      [img]http://example.com/i.jpg[/img]
      ![img](http://example.com/i.jpg)
      ![](http://example.com/i.jpg)
    BBCODE
    expected_html = <<~'HTML'.rstrip
      <p><img src="http://example.com/i.jpg"><br>
      <img src="http://example.com/i.jpg" alt="img"><br>
      <img src="http://example.com/i.jpg" alt=""></p>
    HTML
    expect(Thredded::ContentFormatter.new(nil).format_content(bbcode))
      .to(eq expected_html)
  end

  it 'quotes in bbcode' do
    bbcode = <<~'BBCODE'
      [quote]hi[/quote]
      [quote=john]hey[/quote]
    BBCODE
    expected_html = <<-'HTML'

  <blockquote>
    hi
  </blockquote>



  john says
  <blockquote>
    hey
  </blockquote>
    HTML
    expect(Thredded::ContentFormatter.new(nil).format_content(bbcode))
      .to(eq expected_html)
  end

  it 'nested quotes in bbcode' do
    bbcode = <<~'BBCODE'
      [quote=joel]
      [quote=john]hello[/quote]
      hi
      [/quote]
    BBCODE
    expected_html = <<-HTML

  joel says
  <blockquote>
#{' ' * 4}

  john says
  <blockquote>
    hello
  </blockquote>


hi

  </blockquote>
    HTML
    expect(Thredded::ContentFormatter.new(nil).format_content(bbcode))
      .to(eq expected_html)
  end

  it 'spoilers in bbcode' do
    bbcode = <<~'BBCODE'
      [spoiler]hi[/spoiler] [spoilers]hey[/spoilers]
    BBCODE
    expected_html =
      '<p><span class="thredded--post--content--spoiler">hi</span> ' \
      '<span class="thredded--post--content--spoiler">hey</span></p>'
    expect(Thredded::ContentFormatter.new(nil).format_content(bbcode))
      .to(eq expected_html)
  end

  it 'links' do
    bbcode = '[url]http://example.com[/url]'
    expected_html =
      '<p><a href="http://example.com" target="_blank"' \
      ' rel="nofollow noopener">example.com</a></p>'
    expect(Thredded::ContentFormatter.new(nil).format_content(bbcode))
      .to(eq expected_html)
  end
end
