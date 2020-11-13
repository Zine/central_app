class SalesController < ApplicationController
    include SalesHelper

    skip_before_action :verify_authenticity_token

    def index
    end

    def sales_cero
        route, from_date, to_date = params[:route], params[:from_date].gsub('-',''), params[:to_date].gsub('-','')
        records = sales_zero(route, from_date, to_date)
        filename = "Ventas_0_#{Date.today.strftime('%d%m')}.xlsx"

        if records.length > 0
            xlsx = Axlsx::Package.new

            text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
            only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')

            xlsx.workbook.add_worksheet(name: "Ventas 0 - #{route}") do |sheet|
                sheet.add_row ["Codigo", "Clientes"], style: [text_bold, text_bold]
                records.each do |r|
                    sheet.add_row [r['Codigo'], r['Cliente']], style: [only_border, only_border], :types => [:string, :string]
                end
                sheet.add_row ["Total", records.length], style: [text_bold, only_border]
            end

            xlsx.serialize("public/#{filename}")
            send_file "public/#{filename}"
        end
    end

    def report_sales_daily; end

    def generate_report_sales_daily
        begin
            from_date, to_date = params[:from_date].gsub('-',''), params[:to_date].gsub('-','')
            dates = get_dates_report_sales_daily(from_date, to_date)
            filename = "Ventas_#{from_date}_#{to_date}.xlsx"
            
            if dates.length > 0
                xlsx = Axlsx::Package.new

                text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
                only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
                number_format = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, num_fmt: 2, font_name: 'Calibri')

                dates.each do |date|
                    xlsx.workbook.add_worksheet(name: date['FECHA'].gsub('/', '-')) do |sheet|
                        records = get_documents_report_sales_daily(date['RDate'])
                        sheet.add_row ['Fecha', 'Ruta', 'Tipo', 'Documento', 'Cliente', 'Cajas', 'Tasa', 'Subtotal', 'IVA', 'Total', 'Documento Afectado', 'Mensaje'], style: text_bold
                        records.each do |r|
                            sheet.add_row [r['Fecha'], r['Ruta'], r['Tipo'], r['Documento'], r['Cliente'], r['Cajas'], r['Tasa'], r['Subtotal'], r['IVA'], r['Total'], r['DocumentoAfectado'], r['Mensaje']], style: [only_border, only_border, only_border, only_border, only_border, number_format, number_format, number_format, number_format, number_format, only_border, only_border], types: [:string, :string, :string, :string, :string, :float, :float, :float, :float, :float, :string, :string]
                        end
                    end
                end
            end

            xlsx.serialize("public/#{filename}")
            send_file "public/#{filename}"
        ensure
            ActiveRecord::Base.connection_pool.release_connection
        end
    end

    def sku_view; end

    def sku
        begin
            xlsx = Axlsx::Package.new

            header_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', alignment: { horizontal: :center })
            only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
            text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
            number_format = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, num_fmt: 4, font_name: 'Calibri')

            from_date, to_date = params[:from_date], params[:to_date]
        
            filename = "SKU_Comision_#{from_date}_#{to_date}.xlsx"

            query = "CALL ventas_concurso_1('#{from_date}', '#{to_date}')"
            results = ActiveRecord::Base.connection.execute(query)

            xlsx.workbook.add_worksheet(name: "Ventas") do |sheet|
                sheet.add_row ['Ruta', 'Codigo', 'Producto', 'Comision', 'Cajas', 'Precio Total'], style: header_bold
                results.each {|r| sheet.add_row r, style: [only_border, only_border, only_border, only_border, only_border, number_format], types: [:string, :string] }
            end
        
            xlsx.serialize("public/#{filename}")
            send_file "public/#{filename}"
        ensure
            ActiveRecord::Base.connection_pool.release_connection
        end
    end

    def enjabonate_xlsx
        begin
            xlsx = Axlsx::Package.new

            header_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', alignment: { horizontal: :center })
            only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
            text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
            number_format = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, num_fmt: 4, font_name: 'Calibri')

            filename = "Enjabonate.xlsx"

            results = 

            xlsx.workbook.add_worksheet(name: "Enjabonate") do |sheet|
                sheet.add_row ['Codigo', 'Cliente', 'Factura', 'Fecha Factura', 'Fecha Vencimiento', 'Cajas'], style: header_bold
                results.each { |r| sheet.add_row  }
            end
        end
    end
    
end
