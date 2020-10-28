module SalesHelper

    def sales_zero(route, from, to)
        sql = "CALL ventas_0('#{route}', '#{from}', '#{to}')"
        ActiveRecord::Base.connection.exec_query(sql)
    end

    def list_route
        sql = "SELECT CODIRUTA AS Route, CONCAT(CODIRUTA, ' - ', TRIM(NOMBVEND)) AS Name FROM truta"
        ActiveRecord::Base.connection.exec_query(sql)    
    end

    def get_dates_report_sales_daily(from_date, to_date)
        sql = "SELECT DATE_FORMAT(FECHA,'%d/%m/%y') AS FECHA, DATE_FORMAT(FECHA, '%Y-%m-%d') AS RDate FROM tfachisa WHERE FECHA BETWEEN '#{from_date}' AND '#{to_date}' GROUP BY FECHA"
        ActiveRecord::Base.connection.exec_query(sql)
    end

    def get_documents_report_sales_daily(date)
        sql = "CALL get_documents_report_sales_daily('#{date}')"
        records = ActiveRecord::Base.connection.exec_query(sql)
        ActiveRecord::Base.clear_active_connections!
        records
    end

end
