class Inventory < ActiveRecord::Base
    self.table_name = "tinvadep"
    self.primary_key = "CODIPROD"

    belongs_to :product, foreign_key: 'CODIPROD'
end