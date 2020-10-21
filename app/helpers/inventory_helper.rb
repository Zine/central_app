module InventoryHelper

    def calculate_base_ult(cost, price) 
        (((3069623.2/3187145.78) * 100) - 100)
    end

    def calculate_ult_cost_por(cost, price)
        ((((cost/price) - 1) * 100) * -1)
    end

end
