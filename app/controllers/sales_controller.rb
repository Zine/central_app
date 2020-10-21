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

            text_bold = xlsx.workbook.styles.add_style(b: true, border: Axlsx::STYLE_THIN_BORDER, :font_name => 'Calibri')
            only_border = xlsx.workbook.styles.add_style(border: Axlsx::STYLE_THIN_BORDER, :font_name => 'Calibri')

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

end
