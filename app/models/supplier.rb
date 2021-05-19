class Supplier < ActiveRecord::Base
    self.table_name = "tproa"
    self.primary_key = "CODIGRUP"

    belongs_to :product, foreign_key: 'CODIGRUP'
end