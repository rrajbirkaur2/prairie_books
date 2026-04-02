ActiveAdmin.register Province do
  permit_params :name, :gst, :pst, :hst

  index do
    selectable_column
    id_column
    column :name
    column "GST %" do |province|
      "#{number_with_precision(province.gst * 100, precision: 2)}%"
    end
    column "PST %" do |province|
      "#{number_with_precision(province.pst * 100, precision: 2)}%"
    end
    column "HST %" do |province|
      "#{number_with_precision(province.hst * 100, precision: 2)}%"
    end
    column "Total Tax %" do |province|
      total = (province.gst + province.pst + province.hst) * 100
      "#{number_with_precision(total, precision: 2)}%"
    end
    actions
  end

  form do |f|
    f.inputs "Province Tax Rates" do
      f.input :name
      f.input :gst, label: "GST Rate (e.g. 0.05 for 5%)",
              hint: "Enter as decimal: 5% = 0.05"
      f.input :pst, label: "PST Rate (e.g. 0.07 for 7%)",
              hint: "Enter as decimal: 7% = 0.07"
      f.input :hst, label: "HST Rate (e.g. 0.13 for 13%)",
              hint: "Enter as decimal: 13% = 0.13"
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row "GST" do |province|
        "#{number_with_precision(province.gst * 100, precision: 2)}%"
      end
      row "PST" do |province|
        "#{number_with_precision(province.pst * 100, precision: 2)}%"
      end
      row "HST" do |province|
        "#{number_with_precision(province.hst * 100, precision: 2)}%"
      end
      row "Total Tax" do |province|
        total = (province.gst + province.pst + province.hst) * 100
        "#{number_with_precision(total, precision: 2)}%"
      end
    end
  end
end
