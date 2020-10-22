class InventoryController < ApplicationController

    include InventoryHelper

    skip_before_action :verify_authenticity_token

    def index
    end

    def list_price
        xlsx = Axlsx::Package.new

        only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, :font_name => 'Calibri')
        text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, :font_name => 'Calibri')

        xlsx.workbook.add_worksheet(name: "Listado") do |sheet|
            sheet.add_row ['CODIPROD', 'DESCPROD', 'ULTICOST', 'VENTLOT1', 'VENT1ME', 'COST1ME', 'VENTAAP', 'VENTABP', 'VENTACP', 'VENTADP', 'VENTAEP', 'TASA', 'COSTO', 'PRECIO'], style: [text_bold, text_bold, text_bold, text_bold, text_bold, text_bold, text_bold, text_bold, text_bold, text_bold, text_bold, text_bold, text_bold, text_bold]
            Product.all.each do |p|
                sheet.add_row [p['CODIPROD'], p['DESCPROD'], p['ULTICOST'], p['VENTLOT1'], p['VENT1ME'], p['COST1ME'], p['VENTAAP'], p['VENTABP'], p['VENTACP'], p['VENTADP'], p['VENTAEP'], '', '' ,''], style: [only_border, only_border, only_border, only_border, only_border, only_border, only_border, only_border, only_border, only_border, only_border, only_border, only_border, only_border], types: [:string]
            end
        end

        xlsx.serialize("public/CambioPrecio.xlsx")
        send_file "public/CambioPrecio.xlsx"
    end

    def price
        xlsx = Roo::Spreadsheet.open(params[:file].tempfile)
        sheet = xlsx.sheet(0)
        sheet.each_with_index(code: 'CODIPROD', name: 'DESCPROD', cost: 'ULTICOST', base: 'VENTLOT1', dolarv: 'VENT1ME', dolarc: 'COST1ME', pricea: 'VENTAAP', priceb: 'VENTABP', pricec: 'VENTACP', priced: 'VENTADP', pricee: 'VENTAEP') do |h, i|
            if i > 0 
                change_price(h)
            end
        end
    end

end
