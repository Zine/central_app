module DebtsHelper

    def get_client(code)
        sql = "SELECT * FROM tcpca WHERE tcpca.CODICLIE IN ('#{code}')"
        records = ActiveRecord::Base.connection.exec_query(sql)
        ActiveRecord::Base.clear_active_connections!
        records
    end

    def get_debts(code)
        sql = "CALL get_document_debts('#{code}')"
        @records = ActiveRecord::Base.connection.exec_query(sql)
        ActiveRecord::Base.clear_active_connections!
        @records
    end

end
