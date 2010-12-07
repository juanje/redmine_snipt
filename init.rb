#
# vendor/plugins/redmine_snipt/init.rb
#
require 'redmine'
require 'net/http'

Redmine::Plugin.register :redmine_snipt do
  name 'Redmine Snipt embed plugin'
  author 'Emergya Consultoría'
  description 'Plugin that let the user embed into a wiki page a snippet' +
              'from Snipt.net'
  version '0.1.0'

  Redmine::WikiFormatting::Macros.register do
    desc "Embed snippet from Snipt.net. Use:\n\n  !{{snipt(id)}}\n\n" +
         "Example: \n\n  !{{snipt(21884)}}\n\n"
    macro :snipt do |obj, args|
      return if args.empty?
      result = Net::HTTP.get("snipt.net", "/api/snipts/#{args[0]}.json")
      snipt = ActiveSupport::JSON.decode result
      snipt_url = "http://snipt.net/#{snipt['user']}/#{snipt['slug']}"
      out = ''
      out << content_tag('span', link_to(h(snipt['description']), snipt_url), :class => 'url')
      out << content_tag('code', snipt['formatted_code'])
      content_tag('dl', out)
    end

  end
end
