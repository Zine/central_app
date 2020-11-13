class DebtsController < ApplicationController

    def index; end

    def show
        respond_to do |format|
            format.js do
                sql = "CALL get_document_debts('#{params[:code]}')"
                @records = ActiveRecord::Base.connection.exec_query(sql)
                ActiveRecord::Base.clear_active_connections!
                @records
            end
            format.html 
        end
    end

end
