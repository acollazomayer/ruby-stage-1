require 'net/http'
require 'uri'
require 'json'
require 'yaml'

module Request
  @config = YAML.load_file('config/config.yml')

  def self.post(body)
    uri = URI(@config['gist_api'])
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = body.to_json
    httpBuild(uri).request(req)
  end

end

def httpBuild(uri)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == "https")
  http
end
