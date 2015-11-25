require "captchme/version"

module CAPTCHME
  require 'net/http'
  require "uri"

  class Captchme
    def initialize(private_key, params, ip_client)
      @private_key = private_key
      @data = "private_key=" +  @private_key + "&challenge_key="+
      params["captchme_challenge_field"] + "&response=" +
      params["captchme_response_field"] + "&user_ip=" + ip_client;
      @headers = {
        "Content-Type" => "application/x-www-form-urlencoded",
        "Content-length" => @data.length.to_s,
        "Connection" => "close"
      }
      @uri = URI("http://api.captchme.net/api/verify")
      @http = Net::HTTP.new(@uri.host, @uri.port)
    end

    def request
      @response = @http.post(@uri.path, @data, @headers).body.split
    end

    def is_valid?
      @response[0] == 'true'
    end
  end

end
