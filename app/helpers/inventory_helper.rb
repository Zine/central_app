module InventoryHelper

    def price_list_data
        sql = "CALL get_price_list()"
        records = ActiveRecord::Base.connection.exec_query(sql)
        ActiveRecord::Base.clear_active_connections!
        records
    end

    def price_list_coro_data
        sql = "CALL get_price_list_coro()"
        records = ActiveRecord::Base.connection.exec_query(sql)
        ActiveRecord::Base.clear_active_connections!
        records
    end

    def calculate_ult_cost_por(cost, price) 
        (((price/cost) * 100) - 100)
    end

    def calculate_ult_por(cost, price)
        ((((cost/price) - 1) * 100) * -1)
    end

    def calculate_base(cost, price)
        ((((price/cost) - 1) * 100) * -1)
    end

    def change_price(hash)
        product = Product.find_by(CODIPROD: hash[:code].to_s)
        product.ULTICOST = hash[:cost].round(4)
        product.COSPROM1 = hash[:cost].round(4)
        product.COSTLOT1 =  hash[:cost].round(4)
        product.VENTLOT1 = hash[:base].round(4)
        product.VENT1ME = hash[:dolarv].round(2)
        product.COST1ME = hash[:dolarc].round(2)
        product.ULTCOSME = hash[:dolarc].round(2)
        product.VENTAA = calculate_base(hash[:cost], hash[:pricea]).round(6)
        product.VENTAB = calculate_base(hash[:cost], hash[:priceb]).round(6)
        product.VENTAC = calculate_base(hash[:cost], hash[:pricec]).round(6)
        product.VENTAD = calculate_base(hash[:cost], hash[:priced]).round(6)
        product.VENTAE = calculate_base(hash[:cost], hash[:pricee]).round(6)
        product.VENTUC = calculate_ult_cost_por(hash[:cost], hash[:base]).round(4)
        product.VENTUCA = calculate_ult_cost_por(hash[:cost], hash[:pricea]).round(4)
        product.VENTUCB = calculate_ult_cost_por(hash[:cost], hash[:priceb]).round(4)
        product.VENTUCC = calculate_ult_cost_por(hash[:cost], hash[:pricec]).round(4)
        product.VENTUCD = calculate_ult_cost_por(hash[:cost], hash[:priced]).round(4)
        product.VENTUCE = calculate_ult_cost_por(hash[:cost], hash[:pricee]).round(4)
        product.VENTAAP = hash[:pricea].round(4)
        product.VENTABP = hash[:priceb].round(4)
        product.VENTACP = hash[:pricec].round(4)
        product.VENTADP = hash[:priced].round(4)
        product.VENTAEP = hash[:pricee].round(4)
        product.MARGENKG = hash[:util].round(2)
        if product.save
            puts "#{product.DESCPROD} guardado"
        else
            puts "#{product.DESCPROD} no guardado"
        end
    end

end
