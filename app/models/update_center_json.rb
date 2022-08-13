require 'open-uri'
require 'tempfile'
require 'fileutils'

class UpdateCenterJSON
  DEFAULT_URL ='https://updates.jenkins-ci.org/update-center.json'
  TMP_PATH = if ENV['CI']
    '/tmp/'
  else
    File.dirname(__FILE__) + '/../../tmp/'
  end
  CACHE_PATH = "#{TMP_PATH}update-center.json"

  def self.get
    cached = false
    json = ''
    if File.exist?(CACHE_PATH)
      mtime = File::mtime(CACHE_PATH)
      if Time.now - 6 * 60 * 60 < mtime
        json = open(CACHE_PATH).read
        cached = true
      end
    end
    unless cached
      json = URI.open(DEFAULT_URL).read
      Tempfile.open('update-center.json') do |fp|
        fp.write json
        fp.close
        FileUtils.copy(fp.path, CACHE_PATH)
      end
      mtime = File::mtime(CACHE_PATH)
    end

    json = json.sub('updateCenter.post(', '').sub(/\);$/, '')
    [json, mtime, cached]
  end
end
