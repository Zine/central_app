class ClientController < ApplicationController

    def index
        @clients = Client.all
    end

    def show
        @client = Client.find(params[:id])

        render plain: @client.inspect
    end

end