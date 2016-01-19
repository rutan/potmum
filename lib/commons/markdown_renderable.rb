module MarkdownRenderable
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      def markdown_html
        render_result[:output].to_s
      end

      def markdown_toc_html
        @markdown_toc_html ||= begin
          doc = Nokogiri::XML::Document.new
          root = ul = Nokogiri::XML::Element.new('ul', doc)

          base_level = nil
          old_level = 0
          render_result[:output].css('h1, h2, h3, h4, h5, h6').each do |element|
            level = [element.name.remove('h').to_i - base_level.to_i, 0].max
            unless base_level
              base_level = level
              level = 0
            end

            diff = level - old_level
            diff.abs.times do |_i|
              if diff > 0
                ul.add_child(Nokogiri::XML::Element.new('li', doc)) if ul.children.empty?
                old_ul = ul
                ul = Nokogiri::XML::Element.new('ul', doc)
                old_ul.children.last.add_child(ul)
              else
                ul = ul.parent.parent if ul.parent && ul.parent.parent
              end
            end

            link = element.css('a').first.dup
            link.children.remove
            link.add_child(Nokogiri::XML::Text.new(element.text, doc))
            li = Nokogiri::XML::Element.new('li', doc)
            li.add_child(link)
            ul.add_child(li)

            old_level = level
          end
          root.to_s
        end
      end

      def render_result
        @render_result ||= MarkdownRenderable.render(public_send(self.class.markdown_column_get) || '')
      end
    end
  end

  module ClassMethods
    def markdown_column(column)
      @_markdown_column = column
    end

    def markdown_column_get
      @_markdown_column
    end
  end

  def self.render(text)
    @processor ||= Qiita::Markdown::Processor.new.tap do |processor|
      processor.filters << HTML::Pipeline::NicoLinkFilter
      processor.filters << RedirectURLFilter if GlobalSetting.use_redirector?
    end
    @processor.call(text, base_url: '/users')
  end
end
