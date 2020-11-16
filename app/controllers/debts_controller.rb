class DebtsController < ApplicationController
    include DebtsHelper

    def index; end

    def show
        respond_to do |format|
            format.js do
                @client = get_client(params[:code])
                @records = get_debts(params[:code])
            end
            format.html 
        end
    end

    def report_debts; end

    def generate_report_debts
        begin
            xlsx = Axlsx::Package.new

            header_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', alignment: { horizontal: :center })
            only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', locked: false)
            text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri')
            only_border_locked = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', locked: false)
            text_bold_locked = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, font_name: 'Calibri', locked: false)
    
            d = Date.today
            filename = "Reporte_#{d.day}_#{d.month}.xlsx"
    
            query = "CALL api_get_debts()"
            results = ActiveRecord::Base.connection.execute(query)
    
            xlsx.workbook.add_worksheet(name: "Reporte de Cobranzas") do |sheet|
                sheet.add_row ['TIPO', 'DOCUMENTO', 'CODIGO', 'CLIENTE', 'DIAVISITA', 'RUTA', 'EMISION', 'ESTADO', 'DESPACHO', 'DIAS', 'ANALISISDEVENC', 'ANALISISDEVENCII', 'TOTALBS', 'RESTANTE', 'SALDOBS', 'TOTALME', 'SALDOME'], style: header_bold
                results.each {|r| sheet.add_row r, style: [only_border] }
            end
        
            xlsx.serialize("public/#{filename}")
            send_file "public/#{filename}"
        ensure
            ActiveRecord::Base.connection_pool.release_connection
        end
    end

end
