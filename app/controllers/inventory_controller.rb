class InventoryController < ApplicationController

    include InventoryHelper

    skip_before_action :verify_authenticity_token

    def index
        puts calculate_ult_cost_por(2852640, 6556414.18)
    end

end
