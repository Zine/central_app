class DebtsController < ApplicationController
    include DebtsHelper

    def index; end

    def show
        respond_to do |format|
            format.js do
                @client = get_client(params[:code])
                @records = get_debts(params[:code])
            end
            format.html 
        end
    end

end
