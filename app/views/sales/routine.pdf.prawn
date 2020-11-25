pdf = Prawn::Document.new
image = '/home/zine/Devel/Ruby/central_app/app/assets/images/logo_central_horizontal.png'
enteprise_data = '<b>DISTRIBUIDORA CENTRAL DE ALIMENTOS PARAGUANA C.A</b><br><font size="11">J410114452</font>'
route = params[:route].to_s
day = params[:day].to_i

pdf.repeat :all do
  # Header
  pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width do
    pdf.table(
      [
        [{ image: image, image_width: 100 }, enteprise_data]
      ], cell_style: { inline_format: true, border_width: 1 }, width: pdf.bounds.width
    )

    pdf.move_down 20
    pdf.text "<font size='10'><b>LISTADO DE CLIENTES</b></font>", inline_format: true, align: :center
    pdf.move_down 2
    pdf.text "<font size='10'><b>RUTA:</b> #{route} - <b>DÍA:</b> #{list_days[day][:name]}</font>", inline_format: true
  end
end

pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 110], width: pdf.bounds.width, height: pdf.bounds.height - 140) do
  @clients.each do |client|
    doc = last_document_by_client(client['code'].to_s)
    products_array = []
    text = ''
    last_document_products_by_client(client['code'].to_s).each do |p|
      text += "<font size='9'>#{p['code']} - #{p['name']}<br></font>"
    end

    products_array = if doc.length > 0
                       ["<font size='10'><b>Ultima Factura</b><br>#{doc.first['document']}</font>", text]
                     else
                       ['', '']
                     end

    accounts_array = []
    text = ''

    account_arrays = []

    accounts_array_title = [
      "<b><font size='10'>Documento</font></b>",
      "<b><font size='10'>Monto</font></b>",
      "<b><font size='10'>Facturado</font></b>",
      "<b><font size='10'>Entregado</font></b>"
    ]

    account_arrays.push(accounts_array_title)

    pending_documents_by_client(client['code'].to_s).each do |p|
      account_arrays.push(["<font size='10'>#{p['document']}</font>", "<font size='10'>$ #{p['monto']}</font>", "<font size='10'>#{p['FechaFac']}</font>", "<font size='10'>#{p['FechaEnt']}</font>"])
    end

    accounts_array_detail = pdf.make_table(
      account_arrays, cell_style: { inline_format: true }, column_widths: [pdf.bounds.width * 0.2, pdf.bounds.width * 0.2, pdf.bounds.width * 0.2, pdf.bounds.width * 0.2]
    )
    accounts_array = ["<font size='10'><b>Documentos pendientes</b></font>", text]

    pdf.table(
      [
        ["<font size='10'><b>Codigo:</b> #{client['code']}</font><br><font size='10'><b>Tel:</b> #{client['phone']}</font><br><font size='10'><b>Día:</b> #{list_days[client['day'].to_i][:name]}</font>", "<font size='10'><b>Cliente:</b> #{client['name']}<br><b>Dirección:</b> #{client['direction']}</font>"],
        products_array,
        ["<font size='10'><b>Documentos pendientes</b></font>", accounts_array_detail]
      ], cell_style: { inline_format: true }, column_widths: [pdf.bounds.width * 0.2, pdf.bounds.width * 0.8]
    )
    pdf.move_down 20
  end
  # Footer
  pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom - 10], width: pdf.bounds.width do
    pdf.number_pages '<b>Paginas:</b> <page> /<total>', inline_format: true
  end
end
pdf.render
