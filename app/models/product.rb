class Product < ActiveRecord::Base
    self.table_name = "tinva"
    self.primary_key = "CODIPROD"

    has_many :supplier, foreign_key: 'CODIGRUP'
    has_many :inventory, foreign_key: 'CODIPROD'
end