class Client < ActiveRecord::Base
    self.table_name = "tcpca"
    self.primary_key = "CODICLIE"
end