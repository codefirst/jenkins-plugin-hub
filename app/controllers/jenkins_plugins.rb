require 'open-uri'
require 'json'
JenkinsPluginHub.controllers :jenkins_plugins do

  get :show do
    json = ''
    open('http://mirror.xmission.com/jenkins/updates/update-center.json') do |f|
      json = f.read
    end
    json = json.sub('updateCenter.post(', '').sub(/\);$/, '')
    @plugins = JSON.parse(json)
    render 'jenkins_plugins/show'
  end

end
