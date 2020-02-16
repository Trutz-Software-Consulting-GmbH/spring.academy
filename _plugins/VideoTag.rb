module Jekyll
  class VideoTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
      params = markup.strip.split(/(.*?) (.*)/)
      @url = params[1].strip
      @description = params[2].strip
    end

    def render(context)
      tmpl_path = File.join Dir.pwd, "_includes", "video.html"
      if File.exist?(tmpl_path)
        tmpl = File.read tmpl_path
        site = context.registers[:site]
        tmpl = (Liquid::Template.parse tmpl).render payload(context)
      end
    end

    def payload(context)
      Jekyll::Utils.deep_merge_hashes(
        context.registers[:site].site_payload,
        "page" => context.registers[:page],
        "video" => @url,
        "description" => @description)
    end

  end
end

Liquid::Template.register_tag('video', Jekyll::VideoTag)
