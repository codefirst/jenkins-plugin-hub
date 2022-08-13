require 'json'

JenkinsPluginHub.controllers :jenkins_plugins do
  CATEGORIES = %w{scm misc notifier listview-column builder user ui
      report maven buildwrapper post-build upload external trigger
      page-decorator slaves scm-related cluster cli envfile must-be-labeled
  }

  get :show, :map => '/', :provides => [:html, :rss] do
    json, mtime, cached = UpdateCenterJSON.get

    @category = params[:category] || 'All'
    @categories = ::CATEGORIES
    @word = params[:word] || ''
    @plugins = {'plugins' => {}}
    @all_plugins_count = 0
    @mtime = mtime
    @cached = cached

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
