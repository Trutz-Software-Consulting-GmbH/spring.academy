module Jekyll
  class VideoTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
      params = markup.split
      @video = params.shift.strip
      @description = params.shift.strip
    end

    def render(context)
      tmpl_path = File.join Dir.pwd, "_includes", "video.html"
      if File.exist?(tmpl_path)
        tmpl = File.read tmpl_path
        site = context.registers[:site]
        tmpl = (Liquid::Template.parse tmpl).render site.site_payload.merge!({"video" => @video, "description" => @description})
      end
    end
  end
end

Liquid::Template.register_tag('video', Jekyll::VideoTag)
