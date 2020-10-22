class Product < ActiveRecord::Base
    self.table_name = "tinva"
    self.primary_key = "CODIPROD"
end