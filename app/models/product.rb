class Product < ActiveRecord::Base
    self.table_name = "tinva"
    self.primary_key = "CODIPROD"

    has_many :inventory, foreign_key: 'CODIPROD'
end