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
    begin
      response = http_build(uri).request(req)
      {body: JSON.parse(response.body), code: response.code }
    rescue EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => error
      error.to_s
    end
  end

end

def http_build(uri)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == "https")
  http
end
