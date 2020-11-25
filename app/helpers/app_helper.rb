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
                request.add_field("Authorization", "Bearer #{api_token}")
                request.body = data
                response = http.request request
            end
        end

        response
    end

    def insert_order_a(order)
        begin
            d = Date.parse(order['createDate'])
            fd = "#{d.year}-#{d.month}-#{d.day} 00:00:00"
            sum = order['orderProducts'].inject(0) { |s,x| s + (x['price'] * x['stock']).round(2) }
            sql = "INSERT INTO ventoradm001.tfacpeda (NUMEPEDI, CODICLIE, CODIRUTA, FECHA, CAJAS, NUMEFACT, GRUPFACT, MOTIRECH, FECHFACT, DIASCRED, MENSAJE, PORCGLOB, CODIGLOB, TIPODIFE, FALTFACT, MONEDA, CTO, FECHENT, FECHREC, PORCGLO2, CODIGLO2, CONCENAC, ACTIVIDAD, TRANSFER, VENTORAC, VENTORTR, CONCENTR, CODIOPER, RESERVAOK, ORIGPEDI, CODIMENS, GUIAPEDI, CODIALMA, PAGADO, TOTAPEDI, NOTAENTR, NUMEBULT, MONTGLO2, LATITUD, LONGITUD, NNULO, TOTIMPLIC, NEFECTIVO, BASEPERCI, IVAPERCI, FRECUENCIA, CC, CAMBDOL) VALUES ('#{order['document']}', '#{order['code']}', '#{order['route']}', '#{fd}', 0, ' ', '1', ' ', '0000-00-00 00:00:00', 0, '', 0, ' ', ' ', 0, '02', 0, '0000-00-00 00:00:00', '#{fd}', 0, ' ', ' ', ' ', 0, ' ', 0, 0, ' ', 0, ' ', ' ', ' ', ' ', 0, #{sum}, ' ', 0, 0, ' ', ' ', 0, 0, 0, 0, 0, ' ', 0, 0.0);"

            insert_order_b(order)
        rescue => exception
            puts exception
        ensure
            # ActiveRecord::Base.connection_pool.release_connection
        end
    end

    def insert_order_b(order)
        begin
            d = Date.parse(order['createDate'])
            fd = "#{d.year}-#{d.month}-#{d.day} 00:00:00"
            doc = order['document']
            order['orderProducts'].each do |p|
                sql = "INSERT INTO ventoradm001.tfacpedb (NUMEPEDI, CODIPROD, LINENUME, CODICLIE, FECHA, CODIREAL, TIPOPREC, CAJAS, UNIDADES, UNIDDESP, CODIRUTA, DESCUENTO, ESCALA, DESCUENTOG, CODPROMO, LOTE, KILOS, KILODESP, RESERVAOK, PRECIO, IMPU1, CAJAINVE, UNIDINVE, PROMOCION, DEPOSITO, TIPODIFE, PESADO, DETAL, NUMEGUIA, GRUPFACT, DESCUENT2, DESCUENTG2, CONCENAC, ACTIVIDAD, TRANSFER, VENTORAC, VENTORTR, CONCENTR, CODIOPER, GUIAPEDI, PICKCAJ, PICKUNI, CODIALMA, DESG2DEV, UNIDBACK, IMPUESTOS, BASEPERCI, IVAPERCI, FRECUENCIA, CC, MONEDA, CAMBDOL) VALUES ('#{order['document']}', '#{p['code']}', ' ', '#{order['code']}', '#{d}', ' ', '#{p['priceType']}', 0, 12, 0, '#{order['route']}', 0, ' ', 0, ' ', '1', 0, 0, 0, #{p['price'].round(2)}, #{p['tax']}, 0, 0, 0, '01', ' ', 1, 0, ' ', '1', 0, 0, ' ', ' ', 0, ' ', 0, 0, ' ', ' ', 0, 0, ' ', 0, 0, 0, 0, 0, '', 0, '02', 0.0);"
                puts sql
            end
        rescue => exception
            puts exception
        ensure
            # ActiveRecord::Base.connection_pool.release_connection
        end
    end

end
