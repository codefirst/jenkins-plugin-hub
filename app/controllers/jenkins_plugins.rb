require 'open-uri'
require 'json'
JenkinsPluginHub.controllers :jenkins_plugins do

  get :show, :map => '/', :provides => [:html, :rss] do
    json = ''
    json_url = File.dirname(__FILE__) + '/../../tmp/update-center.json'
    json_url = 'http://mirror.xmission.com/jenkins/updates/update-center.json' unless File.exist?(json_url)
    open(json_url) do |f|
      json = f.read
    end
    json = json.sub('updateCenter.post(', '').sub(/\);$/, '')

    @category = params[:category] || 'All'
    @word = params[:word] || ''
    @plugins = {'plugins' => {}}
    @all_plugins_count = 0

    JSON.parse(json)['plugins'].each do |key, value|
      text = value['title'] + '\t' + value['excerpt']
      re = Regexp.new(@word, Regexp::IGNORECASE)
      if ((@category == 'All' || (value['labels']||[]).include?(@category)) &&
          (@word == '' || re =~ text))
        @plugins['plugins'][key] = value
      end
      @all_plugins_count += 1
    end

    @categories = [
      "scm",
      "misc",
      "notifier",
      "listview-column",
      "builder",
      "user",
      "ui",
      "report",
      "maven",
      "buildwrapper",
      "post-build",
      "upload",
      "external",
      "trigger",
      "page-decorator",
      "slaves",
      "scm-related",
      "cluster",
      "cli",
      "envfile",
      "must-be-labeled"
    ]
    if content_type == :rss
      render 'jenkins_plugins/show_rss'
    else
      render 'jenkins_plugins/show'
    end
  end
end
