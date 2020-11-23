class AuthController < ApplicationController
    include AppHelper

    def index; end

    def login
        username = params[:username]
        password = params[:password]
        @data = nil

        response = Net::HTTP.post(
            URI('https://discentralca.com/auth/login'),
            { "username": username, "password": password }.to_json, 
            "Content-Type" => "application/json"
        )

        @code = response.code

        puts @code.inspect

        if @code == "201"
            @data = JSON.parse response.body
            cookies[:api_token] = { value: @data['access_token'], expires: 1.hour }
        end

        respond_to do |format|
            format.html do
                if @code == '201'
                    redirect_to '/app', flash: { success: "Bienvenido, #{username}" }
                else
                    redirect_to '/auth', flash: { error: "No se puedo autentificar el usuario" }
                end
            end
        end
    end

    def register
        if request.post?
            username = params[:username]
            password = params[:password]
            payload = { "username": username, "password": password }.to_json
    
            res = get_response(API_URL[6], 'post', payload)

            if res.code == "201"
                redirect_to '/auth', flash: { success: "Usuario creado" }
            else
                redirect_to '/auth/register', flash: { error: "No se puedo crear el usuario" }
            end
        end
    end

end
