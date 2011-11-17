require 'open-uri'
require 'json'
JenkinsPluginHub.controllers :jenkins_plugins do

  get :show, :map => '/' do
    json = ''
    open('http://mirror.xmission.com/jenkins/updates/update-center.json') do |f|
    #open(File.dirname(__FILE__) + '/../../tmp/update-center.json') do |f|
      json = f.read
    end
    json = json.sub('updateCenter.post(', '').sub(/\);$/, '')
    @plugins = JSON.parse(json)
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
    render 'jenkins_plugins/show'
  end
end
