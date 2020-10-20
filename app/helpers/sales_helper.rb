module SalesHelper

    def sales_zero(route, from, to)
        sql = "CALL ventas_0('#{route}', '#{from}', '#{to}')"
        ActiveRecord::Base.connection.exec_query(sql)
    end

    def list_route
        sql = "SELECT CONCAT(CODIRUTA, ' - ', TRIM(NOMBVEND)) AS Route FROM truta"
        ActiveRecord::Base.connection.exec_query(sql)    
    end

end
