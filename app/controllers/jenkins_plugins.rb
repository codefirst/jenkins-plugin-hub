require 'open-uri'
require 'json'
JenkinsPluginHub.controllers :jenkins_plugins do
  DEFAULT_URL ='http://mirror.xmission.com/jenkins/updates/update-center.json'
  CACHE_PATH = File.dirname(__FILE__) + '/../../tmp/update-center.json'
  CATEGORIES = %w{scm misc notifier listview-column builder user ui
      report maven buildwrapper post-build upload external trigger
      page-decorator slaves scm-related cluster cli envfile must-be-labeled
  }

  get :show, :map => '/', :provides => [:html, :rss] do
    @cached = false
    json = ''
    if File.exist?(::CACHE_PATH)
      mtime = File::mtime(::CACHE_PATH)
      if Time.now - 6 * 60 * 60 < mtime
        json = open(::CACHE_PATH).read
        @cached = true
      end
    end
    unless @cached
      json = open(::DEFAULT_URL).read
      open(::CACHE_PATH, 'wb').write(json)
      mtime = File::mtime(::CACHE_PATH)
    end

    json = json.sub('updateCenter.post(', '').sub(/\);$/, '')

    @category = params[:category] || 'All'
    @categories = ::CATEGORIES
    @word = params[:word] || ''
    @plugins = {'plugins' => {}}
    @all_plugins_count = 0
    @mtime = mtime

    JSON.parse(json)['plugins'].each do |key, value|
      text = value['title'] + '\t' + value['excerpt']
      re = Regexp.new(@word, Regexp::IGNORECASE)
      if ((@category == 'All' || (value['labels']||[]).include?(@category)) &&
          (@word == '' || re =~ text))
        @plugins['plugins'][key] = value
      end
      @all_plugins_count += 1
    end

    if content_type == :rss
      render 'jenkins_plugins/show_rss'
    else
      render 'jenkins_plugins/show'
    end
  end
end
