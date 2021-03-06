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
        number_format_locked = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, num_fmt: 2, font_name: 'Calibri', locked: true)
        number_format_unlocked = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, num_fmt: 2, font_name: 'Calibri', locked: false)
        text_bold_locked = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', locked: true)

        # xlsx.workbook.add_worksheet.

        xlsx.workbook.add_worksheet(name: "Listado") do |sheet|
            sheet.sheet_protection.password = "central"
            #                   A       B           C               D           E           F           G           H       I           J           K       L        M        N             O                P
            sheet.add_row ['CODIGO', 'NOMBRE', 'ULTIMOCOSTO', 'PRECIOBASE', 'PRECIOME', 'COSTOME', 'PRECIOA', 'PRECIOB', 'PRECIOC', 'PRECIOD', 'PRECIOE', 'COSTO', 'UTILIDAD', 'PRECIOPARAGUANA', 'PRECIOCORO'], style: [text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked, text_bold_locked]
            Product.joins(:inventory).where(DESACTIV: 0).where('tinvadep.CANTIDAD > 0').where("tinvadep.CODIDEPO = '01'").all.each_with_index do |p, i|
                c = i + 2
                sheet.add_row [
                    p['CODIPROD'].strip, 
                    p['DESCPROD'], 
                    "=L#{c}", 
                    "=L#{c}", 
                    "=N#{c}", 
                    "=L#{c}", 
                    p['CPESANIT'].to_i == 1 ?  "=H#{c}" : p['IMPU1'] == 16.0 ? "=H#{c}*1.16" : "=H#{c}", 
                    "=O#{c}", 
                    "=N#{c}", 
                    "=N#{c}", 
                    "=N#{c}", 
                    p['ULTCOSME'], 
                    (p['MARGENKG']), 
                    if p['CPESANIT'].to_i == 1
                        "=ROUND((L#{c}/((100-M#{c})/100)), 2)"
                    else
                        if p['IMPU1'] == 16.0
                            "=ROUND(ROUND(((L#{c}/((100-M#{c})/100))), 2)*1.16, 2)"
                        else
                            "=ROUND(ROUND(((L#{c}/((100-M#{c})/100))), 2), 2)"
                        end
                    end,
                    # p['IMPU1'] == 16.0 ? "=ROUND(ROUND(((M#{c}/(1-N#{c}))), 2)*1.16, 2)" : "=ROUND((M#{c}/(1-N#{c})), 2)", 
                    "=ROUND((L#{c}/((100-M#{c})/100)), 2)"
                ], style: [only_border_locked, only_border_locked, number_format_locked, number_format_locked, number_format_locked, number_format_locked, number_format_locked, number_format_locked, number_format_locked, number_format_locked, number_format_locked, number_format_locked, number_format_unlocked, number_format_locked, number_format_locked, number_format_locked, number_format_locked, number_format_locked], types: [:string, :string]
            end
        end

        xlsx.serialize("public/CambioPrecio.xlsx")
        send_file "public/CambioPrecio.xlsx"
    end

    def price
        xlsx = Roo::Spreadsheet.open(params[:file].tempfile)
        sheet = xlsx.sheet(0)
        sheet.each_with_index(code: 'CODIGO', name: 'NOMBRE', util: 'UTILIDAD', cost: 'ULTIMOCOSTO', base: 'PRECIOBASE', dolarv: 'PRECIOME', dolarc: 'COSTOME', pricea: 'PRECIOA', priceb: 'PRECIOB', pricec: 'PRECIOC', priced: 'PRECIOD', pricee: 'PRECIOE') do |h, i|
            if i > 0 
                change_price(h)
            end
        end
    end

    def test_price; end

    def test_price_xlsx
        xlsx = Axlsx::Package.new

        only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
        text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
        number_format = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, num_fmt: 2, font_name: 'Calibri')


        xlsx.workbook.add_worksheet(name: "Probador") do |sheet|
            #                  A        B         C        D          E        F  
            sheet.add_row ['CODIGO', 'NOMBRE', 'UND. X CAJA', 'PROVEEDOR', 'EXISTENCIA', 'UTILIDAD', 'COSTO', 'ME A', 'ME B'], style: text_bold
            Product.where(DESACTIV: 0).each_with_index do |p, i|
                inventory = Inventory.where(CODIPROD: p['CODIPROD'].strip, CODIDEPO: '01').first

                c = i + 2
                sheet.add_row [
                    p['CODIPROD'].strip, 
                    p['DESCPROD'].strip,
                    p['UNIDCAJA'].to_i,
                    Supplier.find(p['CODIGRUP'].strip).DESCGRUP.strip,
                    inventory.nil? ? 0 : inventory.CANTIDAD / p['UNIDCAJA'],
                    p['MARGENKG'], 
                    p['ULTCOSME'], 
                    if p['CPESANIT'].to_i == 1
                        "=IFERROR(ROUND((G#{c}/((1-(F#{c}/100)))), 2), 0)"
                            else
                                if p['IMPU1'] == 16.0
                                    "=IFERROR(ROUND((G#{c}/((1-(F#{c}/100))))*1.16, 2), 0)"
                                else
                                    "=IFERROR(ROUND((G#{c}/((1-(F#{c}/100)))), 2), 0)"
                                end
                            end,
                    "=IFERROR(ROUND((G#{c}/((1-(F#{c}/100)))), 2), 0)",
                    "=C#{c}*F#{c}", "=C#{c}*G#{c}" ], 
                    style: [ only_border, only_border, number_format, only_border, number_format, number_format, number_format, number_format, number_format, number_format, number_format, number_format], types: [:string, :string]
        end
    end
        xlsx.serialize("public/ProbadorPrecio.xlsx")
        send_file "public/ProbadorPrecio.xlsx"
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
        filename = "Lista_Pgna_#{d.day}_#{d.month}_#{d.year}.xlsx"

        xlsx.workbook.add_worksheet(name: "Listado") do |sheet|
            sheet.add_row ['CODIGO', 'PRODUCTO', 'UNIDADES', 'CODIGO BARRA', 'DOLAR', 'DOLAR (UND)', 'DOLAR - 8%', 'DOLAR - 8% (UND)', 'DOLAR - 5%', 'DOLAR - 5% (UND)', 'DOLAR - 4%', 'DOLAR - 4% (UND)'], style: header_bold
            price_list_data.each do |d|
                sheet.add_row [
                    d['Codigo'], 
                    d['Producto'], 
                    d['Unidades'], 
                    d['Barra'],
                    d['PrecioDolarFull'], 
                    d['PrecioDolarFullUnidades'], 
                    d['PrecioDolarFull'] * 0.92, 
                    d['PrecioDolarFullUnidades'] * 0.92, 
                    d['PrecioDolarFull'] * 0.95, 
                    d['PrecioDolarFullUnidades'] * 0.95, 
                    d['PrecioDolarFull'] * 0.96, 
                    d['PrecioDolarFullUnidades'] * 0.96
                ], style: [only_border, only_border, only_border, only_border, number_format, number_format, number_format, number_format, number_format, number_format, number_format, number_format], types: [:string, :string, :integer, :string, :float, :float, :float, :float, :float, :float, :float, :float]
            end

            sheet.column_widths 10, 45, 11, 25, 14, 16, 9, 14, 12, 18
        end

        xlsx.serialize("public/#{filename}")
        send_file "public/#{filename}"
    end


    def list_price_auto
        xlsx = Axlsx::Package.new

        only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
        text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
        text_numeric = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, num_fmt: 4, font_name: 'Calibri')

        # Queries
        albeca = Product.joins(:inventory).where("tinvadep.CODIDEPO": "01").where("tinvadep.CANTIDAD > 0").where(CODIGRUP: '001')
        otros = Product.joins(:inventory).where("tinvadep.CODIDEPO": "01").where("tinvadep.CANTIDAD > 0").where.not(CODIGRUP: '001').order(:DESCPROD)
        
        xlsx.workbook.add_worksheet(name: "ListaAlbeca") do |sheet|
            
            sheet.add_row ["CODIGO", "PRODUCTO", "UNIDADES POR CAJA", "PRECIO BS", "PRECIO BS (UND)", "PRECIO DOLAR (CAJA)", "PRECIO DOLAR (UND)"], style: [text_bold, text_bold, text_bold, text_bold, text_bold, text_bold, text_bold] 

            albeca.each do |a|
                sheet.add_row [ a['CODIPROD'], a['DESCPROD'], a['UNIDCAJA'], a['VENTAAP'], "=ROUND(#{a['VENTAAP']/a['UNIDCAJA']}, 2)", a['VENT1ME'], "=ROUND(#{a['VENT1ME']/a['UNIDCAJA']}, 2)"], style: [only_border, only_border, only_border, text_numeric, text_numeric, text_numeric, text_numeric], types: [:string, :string]
            end

            sheet.column_widths 10, 50, 10, 20, 20, 15, 15
        end

        xlsx.workbook.add_worksheet(name: "Precios BS") do |sheet|
            sheet.add_row ["CODIGO", "PRODUCTO", "UNIDADES POR CAJA", "PRECIO BS", "PRECIO BS (UND)"], style: [text_bold, text_bold, text_bold, text_bold, text_bold] 

            otros.each do |a|
                sheet.add_row [ a['CODIPROD'], a['DESCPROD'], a['UNIDCAJA'], a['VENTAAP'], "=ROUND(#{a['VENTAAP']/a['UNIDCAJA']}, 2)"], style: [only_border, only_border, only_border, text_numeric, text_numeric], types: [:string, :string]
            end

            sheet.column_widths 10, 50, 10, 20, 20
        end

        xlsx.workbook.add_worksheet(name: "Precios Dolar") do |sheet|
            sheet.add_row ["CODIGO", "PRODUCTO", "UNIDADES POR CAJA", "PRECIO DOLAR (CAJA)", "PRECIO DOLAR (UND)"], style: [text_bold, text_bold, text_bold, text_bold, text_bold] 

            otros.each do |a|
                sheet.add_row [ a['CODIPROD'], a['DESCPROD'], a['UNIDCAJA'], a['VENT1ME'], "=ROUND(#{a['VENT1ME']/a['UNIDCAJA']}, 2)"], style: [only_border, only_border, only_border, text_numeric, text_numeric], types: [:string, :string]
            end

            sheet.column_widths 10, 50, 10, 15, 15
        end

        xlsx.serialize("public/ProbadorPrecio.xlsx")
        send_file "public/ProbadorPrecio.xlsx"
    end 

    def list_price_auto_coro
        xlsx = Axlsx::Package.new

        # Queries
        albeca = Product.joins(:inventory).where("tinvadep.CODIDEPO": "01").where("tinvadep.CANTIDAD > 0").where(CODIGRUP: '001')
        otros = Product.joins(:inventory).where("tinvadep.CODIDEPO": "01").where("tinvadep.CANTIDAD > 0").where.not(CODIGRUP: '001')
        
        xlsx.workbook.add_worksheet(name: "ListaAlbeca") do |sheet|
            sheet.add_row ["CODIGO", "PRODUCTO", "UNIDADES POR CAJA", "PRECIO BS", "PRECIO BS (UND)", "PRECIO DOLAR (CAJA)", "PRECIO DOLAR (UND)"]

            albeca.each do |a|
                sheet.add_row [ a['CODIPROD'], a['DESCPROD'], a['UNIDCAJA'], a['VENTAAP'], "=ROUND(#{a['VENTAAP']/a['UNIDCAJA']}, 2)", a['VENT1ME'], "=ROUND(#{a['VENT1ME']/a['UNIDCAJA']}, 2)"]
            end
        end

        xlsx.workbook.add_worksheet(name: "Precios BS") do |sheet|
            sheet.add_row ["CODIGO", "PRODUCTO", "UNIDADES POR CAJA", "PRECIO BS", "PRECIO BS (UND)"]

            otros.each do |a|
                sheet.add_row [ a['CODIPROD'], a['DESCPROD'], a['UNIDCAJA'], a['VENTAAP'], "=ROUND(#{a['VENTAAP']/a['UNIDCAJA']}, 2)"]
            end
        end

        xlsx.workbook.add_worksheet(name: "Precios Dolar") do |sheet|
            sheet.add_row ["CODIGO", "PRODUCTO", "UNIDADES POR CAJA", "PRECIO DOLAR (CAJA)", "PRECIO DOLAR (UND)"]

            otros.each do |a|
                sheet.add_row [ a['CODIPROD'], a['DESCPROD'], a['UNIDCAJA'], a['VENT1ME'], "=ROUND(#{a['VENT1ME']/a['UNIDCAJA']}, 2)"]
            end
        end

        xlsx.serialize("public/ProbadorPrecio.xlsx")
        send_file "public/ProbadorPrecio.xlsx"
    end 

    def list_price_coro_xlsx
        xlsx = Axlsx::Package.new

        header_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', alignment: { horizontal: :center })
        
        only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
        text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
        number_format = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, num_fmt: 4, font_name: 'Calibri')

        d = Date.today
        filename = "Lista_Coro_#{d.day}_#{d.month}.xlsx"

        xlsx.workbook.add_worksheet(name: "Listado") do |sheet|
            sheet.add_row ['CODIGO', 'PRODUCTO', 'UNIDADES', 'CODIGO BARRA', 'DOLAR', 'DOLAR (UND)', 'DOLAR - 8%', 'DOLAR - 8% (UND)', 'DOLAR - 5%', 'DOLAR - 5% (UND)', 'DOLAR - 4%', 'DOLAR - 4% (UND)'], style: header_bold
            price_list_coro_data.each do |d|
                sheet.add_row [
                    d['Codigo'], 
                    d['Producto'], 
                    d['Unidades'], 
                    d['Barra'],
                    d['PrecioDolarFull'], 
                    d['PrecioDolarFullUnidades'], 
                    d['PrecioDolarFull'] * 0.92, 
                    d['PrecioDolarFullUnidades'] * 0.92, 
                    d['PrecioDolarFull'] * 0.95, 
                    d['PrecioDolarFullUnidades'] * 0.95, 
                    d['PrecioDolarFull'] * 0.96, 
                    d['PrecioDolarFullUnidades'] * 0.96
                ], style: [only_border, only_border, only_border, only_border, number_format, number_format, number_format, number_format, number_format, number_format, number_format, number_format], types: [:string, :string, :integer, :string, :float, :float, :float, :float, :float, :float, :float, :float]
            end

            sheet.column_widths 10, 45, 11, 25, 14, 16, 9, 14, 12, 18
        end

        xlsx.serialize("public/#{filename}")
        send_file "public/#{filename}"
    end

end