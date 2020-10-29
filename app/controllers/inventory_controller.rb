class InventoryController < ApplicationController

    include InventoryHelper

    skip_before_action :verify_authenticity_token

    def index
    end

    def load_list_price
        xlsx = Axlsx::Package.new

        only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', locked: false)
        text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
        only_border_locked = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', locked: false)
        text_bold_locked = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', locked: false)

        # xlsx.workbook.add_worksheet.

        xlsx.workbook.add_worksheet(name: "Listado") do |sheet|
            sheet.sheet_protection.password = "central"
            #                   A       B           C               D           E           F           G           H       I           J           K       L        M          N                   O
            sheet.add_row ['CODIGO', 'NOMBRE', 'ULTIMOCOSTO', 'PRECIOBASE', 'PRECIOME', 'COSTOME', 'PRECIOA', 'PRECIOB', 'PRECIOC', 'PRECIOD', 'PRECIOE', 'TASA', 'COSTO', 'PRECIOPARAGUANA', 'PRECIOCORO'], style: [text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked]
            Product.where(DESACTIV: 0).all.each do |p|
                sheet.add_row [p['CODIPROD'], p['DESCPROD'], p['ULTICOST'], p['VENTLOT1'], p['VENT1ME'], p['ULTCOSME'], p['VENTAAP'], p['VENTABP'], p['VENTACP'], p['VENTADP'], p['VENTAEP'], '', '' ,'', ''], style: [only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border, only_border, only_border, only_border, only_border], types: [:string]
            end
        end

        xlsx.serialize("public/CambioPrecio.xlsx")
        send_file "public/CambioPrecio.xlsx"
    end

    def load_list_price_new
        xlsx = Axlsx::Package.new

        only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', locked: false)
        text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
        only_border_locked = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', locked: true)
        text_bold_locked = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', locked: true)

        # xlsx.workbook.add_worksheet.

        xlsx.workbook.add_worksheet(name: "Listado") do |sheet|
            sheet.sheet_protection.password = "central"
            #                   A       B           C               D           E           F           G           H       I           J           K       L        M          N                   O
            sheet.add_row ['CODIGO', 'NOMBRE', 'ULTIMOCOSTO', 'PRECIOBASE', 'PRECIOME', 'COSTOME', 'PRECIOA', 'PRECIOB', 'PRECIOC', 'PRECIOD', 'PRECIOE', 'TASA', 'COSTO', 'PRECIOPARAGUANA', 'PRECIOCORO'], style: [text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked]
            Product.where(DESACTIV: 0).all.each_with_index do |p, i|
                c = i + 2
                sheet.add_row [p['CODIPROD'], p['DESCPROD'], "=L#{c}*M#{c}", "=L#{c}*M#{c}", "=N#{c}", "=M#{c}", "=N#{c}*L#{c}", "=O#{c}*L#{c}", "=N#{c}*L#{c}", "=N#{c}*L#{c}", "=N#{c}*L#{c}", '', '' ,'', ''], style: [only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border_locked, only_border, only_border, only_border, only_border, only_border], types: [:string]
            end
        end

        xlsx.serialize("public/CambioPrecio.xlsx")
        send_file "public/CambioPrecio.xlsx"
    end

    def price
        xlsx = Roo::Spreadsheet.open(params[:file].tempfile)
        sheet = xlsx.sheet(0)
        sheet.each_with_index(code: 'CODIGO', name: 'NOMBRE', cost: 'ULTIMOCOSTO', base: 'PRECIOBASE', dolarv: 'PRECIOME', dolarc: 'COSTOME', pricea: 'PRECIOA', priceb: 'PRECIOB', pricec: 'PRECIOC', priced: 'PRECIOD', pricee: 'PRECIOE') do |h, i|
            if i > 0 
                change_price(h)
            end
        end
    end

    def list_price
    end

    def list_price_xlsx
        xlsx = Axlsx::Package.new

        header_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', alignment: { horizontal: :center })
        
        only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
        text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
        number_format = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, num_fmt: 4, font_name: 'Calibri')

        d = Date.today
        filename = "Lista_#{d.day}_#{d.month}.xlsx"

        xlsx.workbook.add_worksheet(name: "Listado") do |sheet|
            sheet.add_row ['CODIGO', 'PRODUCTO', 'UNIDADES', 'PRECIO', 'PRECIO (UND)', 'DOLAR', 'DOLAR (UND)', 'DOLAR (DES)', 'DOLAR (DES)(UND)'], style: header_bold
            price_list_data.each do |d|
                sheet.add_row [d['Codigo'], d['Producto'], d['Unidades'], d['PrecioBolivares'], d['PrecioBolivaresUnidades'], d['PrecioDolarFull'], d['PrecioDolarFullUnidades'], d['PrecioDolar'], d['PrecioDolarUnidades']], style: [only_border, only_border, only_border, number_format, number_format, number_format, number_format, number_format, number_format], types: [:string, :string, :integer, :float, :float, :float, :float, :float, :float]
            end

            sheet.column_widths 10, 45, 11, 14, 16, 9, 14, 12, 18 
        end

        xlsx.serialize("public/#{filename}")
        send_file "public/#{filename}"
    end

end
