require 'open-uri'

class UpdateCenterJSON
  DEFAULT_URL ='https://updates.jenkins-ci.org/update-center.json'
  CACHE_PATH = File.dirname(__FILE__) + '/../../tmp/update-center.json'

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
      open(CACHE_PATH, 'wb').write(json)
      mtime = File::mtime(CACHE_PATH)
    end

    json = json.sub('updateCenter.post(', '').sub(/\);$/, '')
    [json, mtime, cached]
  end
end
