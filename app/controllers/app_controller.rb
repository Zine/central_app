class AppController < ApplicationController
    include AppHelper

    before_action :check_api_token

    def index; end

    def clients
        @active_clients = 'is-active'   
        if request.post?
            res = Net::HTTP.get(URI('http://192.168.0.252/ventor/clients'))
            get_response(API_URL[0], 'post', res)
        end
    end

    def products
        @active_products = 'is-active'
        if request.post?
            res = Net::HTTP.get(URI('http://192.168.0.252/ventor/products'))
            puts get_response(API_URL[1], 'post', res).inspect
        end
    end

    def accounts
        @active_accounts = 'is-active'
        if request.post?
            res = Net::HTTP.get(URI('http://192.168.0.252/ventor/accounts/pendings'))
            get_response(API_URL[8], 'post', res)       
        end
    end

    def orders
        if request.post?
            res = get_response(API_URL[3]).body
            @res = URI.encode(get_response(API_URL[3]).body)

            json = JSON.parse res
            
            begin
                json.each do |j|
                    if j['syncVentor'] != true
                        j['syncVentor'] = true
                        insert_order_a(j)
                    end
                end
            end 
            
            respond_to do |format|
                format.js 
            end
        elsif request.get?
            @active_orders = 'is-active'
        end
    end

    def error; end

    private

    def check_api_token
        if cookies[:api_token].nil?
            redirect_to '/auth' 
        end
    end

end
