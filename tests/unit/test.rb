# frozen_string_literal: true

require 'padrino'
require 'minitest/autorun'
require 'rack/test'
require 'webmock/minitest'

require_relative '../../app/app'
require_relative '../../config/apps'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    WebMock.disable_net_connect!
    jsonp = <<-JSONP
    updateCenter.post(
      {
        "plugins":{
          "bitbucket-oauth":{"buildDate":"Dec 19, 2021","compatibleSinceVersion":"0.8","defaultBranch":"master","dependencies":[],"developers":[{"developerId":"mallowlabs","name":"mallowlabs mallowlabs"}],"excerpt":"This is an authentication plugin for bitbucket.org users","gav":"org.jenkins-ci.plugins:bitbucket-oauth:0.12","issueTrackers":[{"reportUrl":"https://www.jenkins.io/participate/report-issue/redirect/#17643","type":"jira","viewUrl":"https://issues.jenkins.io/issues/?jql=component=17643"}],"labels":["external"],"name":"bitbucket-oauth","popularity":3423,"previousTimestamp":"2021-12-19T05:44:00.00Z","previousVersion":"0.11","releaseTimestamp":"2021-12-19T06:36:44.00Z","requiredCore":"1.645","scm":"https://github.com/jenkinsci/bitbucket-oauth-plugin","sha1":"8fUan5djge2RXp8UAJnkvdD0QnY=","sha256":"XqavP47uKsAsI73vlvZezvgUvzKCv+xq4PUBB+feKBQ=","size":322379,"title":"Bitbucket OAuth","url":"https://updates.jenkins.io/download/plugins/bitbucket-oauth/0.12/bitbucket-oauth.hpi","version":"0.12","wiki":"https://plugins.jenkins.io/bitbucket-oauth"}
        }
      }
    );
    JSONP
    stub_request(:get, 'https://updates.jenkins-ci.org/update-center.json').
      to_return(status: 200, body: jsonp, headers: { content_type: 'application/json' }
  )
  end

  def app
    Padrino.application
  end

  def test_index
    get '/'
    assert(last_response.ok?)
    assert_includes(last_response.body, 'Jenkins Plugin Hub')
    assert_includes(last_response.body, 'Bitbucket OAuth')
  end

  def test_rss
    get '/.rss'
    assert(last_response.ok?)
    assert_includes(last_response.body, "<rss version='2.0'>")
    assert_includes(last_response.body, 'Jenkins Plugin Hub')
    assert_includes(last_response.body, 'Bitbucket OAuth')
  end
end
