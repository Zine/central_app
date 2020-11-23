module AppHelper

    BASE_URL = "https://discentralca.com"

    API_URL = [
        '/api/clients',
        '/api/products',
        '/api/accounts',
        '/api/orders',
        '/api/rates',
        '/auth/login',
        '/auth/register',
        '/api/accounts/pendings',
        '/api/accounts/histories'
    ]

    def get_response(url, method = 'get', data = nil)
        response = nil

        api_token = cookies[:api_token]

        uri = URI("#{BASE_URL}#{url}")
        
        if method == 'get'
            Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
                request = Net::HTTP::Get.new uri, "Authorization" => "Bearer #{api_token}", "Content-Type" => "application/json"
                response = http.request request 
            end
        else 
            Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
                request = Net::HTTP::Post.new uri
                request.add_field("Content-Type", "application/json")
                request.body = data
                response = http.request request
            end
        end

        response
    end

end
