# frozen_string_literal: true

require 'padrino'
require 'minitest/autorun'
#require 'rack/test'
#require 'webmock/minitest'

require_relative '../../app/app'

class AppTest < Minitest::Test
  #include Rack::Test::Methods

  def setup
    #WebMock.disable_net_connect!
  end

  def app
    Padrino.mount("JenkinsPluginHub").to('/')
  end
end
