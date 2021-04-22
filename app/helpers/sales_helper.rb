module SalesHelper
  def sales_zero(route, from, to)
    # sql = "CALL ventas_0('#{route}', '#{from}', '#{to}')"
    sql = <<-SQL
      SELECT#{'  '}
        tcpcarut.CODICLIE AS Codigo,
        TRIM(tcpca.RAZOSOCI) AS Cliente
      FROM tcpcarut
        INNER JOIN tcpca ON tcpcarut.CODICLIE = tcpca.CODICLIE
      WHERE tcpcarut.DESACTIV = 0
        AND tcpcarut.CODIRUTA IN ('#{route}')
        AND tcpcarut.CODICLIE NOT IN (
                                  SELECT tfachisa.CODICLIE
                                    FROM tfachisa
                                  WHERE tfachisa.FECHA#{' '}
                                  BETWEEN '#{from}' AND '#{to}' AND tfachisa.CODIRUTA IN ('#{route}')
                                );
    SQL
    ActiveRecord::Base.connection.exec_query(sql)
  end

  def list_route
    sql = "SELECT CODIRUTA AS Route, CONCAT(CODIRUTA, ' - ', TRIM(NOMBVEND)) AS Name FROM truta"
    ActiveRecord::Base.connection.exec_query(sql)
  end

  def list_days
    [
      { 'id': 0, "name": 'Todos' },
      { 'id': 1, "name": 'Lunes' },
      { 'id': 2, "name": 'Martes' },
      { 'id': 3, "name": 'Miercoles' },
      { 'id': 4, "name": 'Jueves' },
      { 'id': 5, "name": 'Viernes' }
    ]
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

  def get_data_enjabonate
    sql = 'CALL enjabonate()'
    records = ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.clear_active_connections!
    records
  end

  def clients_by_route_day(route, day)
    sql = "
        SELECT tcpcarut.CODICLIE AS code,
        TRIM(tcpca.RAZOSOCI) AS name,
        CONCAT(TRIM(tcpca.DIRECCION1), ' ', TRIM(tcpca.DIRECCION2)) AS direction,
        TRIM(tcpca.TELEFONO1) AS phone,
        tcpcarut.DIAVISI AS day
        FROM tcpca
        INNER JOIN tcpcarut ON tcpca.CODICLIE = tcpcarut.CODICLIE
        WHERE tcpcarut.DESACTIV = 0 AND tcpcarut.CODIRUTA = '#{route}'"
    sql += " AND tcpcarut.DIAVISI = '#{day}'" if day != '0'
    records = ActiveRecord::Base.connection.exec_query(sql)
    ActiveRecord::Base.clear_active_connections!
    records
  end

  def last_document_by_client(client)
    sql = "
        SELECT
        tfachisb.NUMEDOCU AS document
        FROM tfachisb
        WHERE tfachisb.CODICLIE = '#{client}'
        AND tfachisb.TIPODOCU = 'FA'
        ORDER BY tfachisb.FECHA DESC
        LIMIT 1"
    records = ActiveRecord::Base.connection.exec_query(sql)
    ActiveRecord::Base.clear_active_connections!
    records
  end

  def last_document_products_by_client(_client)
    sql = "
        SELECT
        tfachisb.NUMEDOCU AS document
        FROM tfachisb
        WHERE tfachisb.CODICLIE = '#{_client}'
        AND tfachisb.TIPODOCU = 'FA'
        ORDER BY tfachisb.FECHA DESC
        LIMIT 1
    "
    records = ActiveRecord::Base.connection.exec_query(sql)
    ActiveRecord::Base.clear_active_connections!

    if records.length > 0
      sql = "
      SELECT
      tinva.CODIPROD AS code,
      TRIM(tinva.DESCPROD) AS name,
      CAST((tfachisb.UNIDADES / tinva.UNIDCAJA) AS DECIMAL(10,2)) AS box,
      tfachisb.UNIDADES AS units
      FROM tfachisb
      INNER JOIN tinva ON tinva.CODIPROD = tfachisb.CODIPROD
      WHERE tfachisb.NUMEDOCU = '#{records.first['document']}'
  "
      records = ActiveRecord::Base.connection.exec_query(sql)
      ActiveRecord::Base.clear_active_connections!
      records
    else
      []
    end
  end

  def pending_documents_by_client(_code)
    sql = "
    SELECT
      CONCAT(tcpcb.TIPODOCU, '-', tcpcb.NUMEDOCU) AS document,
      CAST((tcpcb.MONTO / tcpcb.CAMBIO) AS DECIMAL (10,2)) AS total,
      CAST((tcpcb.SALDO / tcpcb.CAMBIO) AS DECIMAL (10,2)) AS monto,
      DATE_FORMAT(tcpcb.FECHA, '%d/%m/%Y') AS FechaFac,
      IF(
			DATE_FORMAT( tcpcb.FECHACGS, '%d/%m/%Y' ) = '00/00/0000',
			'No entregado',
			DATE_FORMAT(tcpcb.FECHACGS, '%d/%m/%Y')
		) AS FechaEnt
    FROM tcpcb
    WHERE tcpcb.CODICLIE = '#{_code}' AND tcpcb.TIPODOCU = 'FA'
    "
    records = ActiveRecord::Base.connection.exec_query(sql)
    ActiveRecord::Base.clear_active_connections!
    records
  end
end
