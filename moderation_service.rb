# app/services/moderation_service.rb
require 'net/http'
require 'uri'
require 'json'

class ModerationService
  def self.check_content(content)
    uri = URI('https://moderation.logora.fr/predict')
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = { text: content }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body, symbolize_names: true)
  end
end
