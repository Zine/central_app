module InventoryHelper

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
        product = Product.find_by(CODIPROD: hash[:code])
        product.ULTICOST = hash[:cost].round(4)
        product.VENTLOT1 = hash[:base].round(4)
        product.VENT1ME = hash[:dolarv].round(2)
        product.COST1ME = hash[:dolarc].round(2)
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
        product.save
    end

end
