# VATS ================================================================================================================
puts "\n== Přidávám daňové sazby =="
vats = [{name: 'Bez daně', percentage_value: 0, is_time_limited: false},
        {name: 'Základní sazba DPH - 21%', percentage_value: 21, is_time_limited: false},
        {name: 'Snížená sazba DPH - 15%', percentage_value: 15, is_time_limited: false}]

vats.each do |vat|
  begin
    Vat.create!(vat)
    puts "INFO: Daň [#{vat[:name]}] úspěšně přidána.\n"
  rescue Exception => e
    puts "ERROR: Během přidávání daně [#{vat[:name]}] došlo k následující chybě: #{e.message}\n"
  end
end

# CURRENCIES ==========================================================================================================
puts "\n== Přidávám měny =="
currencies = [{name: 'Česká koruna', code: 'CZK', symbol: 'Kč'},
              {name: 'Americký dolar', code: 'USD', symbol: '$'},
              {name: 'Euro', code: 'EUR', symbol: '€'}]

currencies.each do |currency|
  begin
    Currency.create!(currency)
    puts "INFO: Měna [#{currency[:name]}] úspěšně přidána.\n"
  rescue Exception => e
    puts "ERROR: Během přidávání měny [#{currency[:name]}] došlo k následující chybě: #{e.message}\n"
  end
end

# LOCALES =============================================================================================================
puts "\n== Přidávám dostupné jazyky =="
locales = [{name: 'Čeština', code: 'cs'},
           {name: 'English', code: 'en'}]
locales.each do |locale|
  begin
    Locale.create!(locale)
    puts "INFO: Jazyk [#{locale[:name]}] úspěšně přidána.\n"
  rescue Exception => e
    puts "ERROR: Během přidávání jazyka [#{locale[:name]}] došlo k následující chybě: #{e.message}\n"
  end
end

# VARIABLE FIELD CATEGORIES ===========================================================================================
puts "\n== Přidávám kategorie metrik =="
vfcs = [{name: 'Vytrvalost', description: '', is_global: true, virt_assoc_key: :endurance},
        {name: 'Síla', description: '', is_global: true, virt_assoc_key: :strength},
        {name: 'Rychlost', description: '', is_global: true, virt_assoc_key: :speed},
        {name: 'Pohyblivost', description: '', is_global: true, virt_assoc_key: :mobility},
        {name: 'Koordinace', description: '', is_global: true, virt_assoc_key: :coordination},
        {name: 'Antropologické údaje', description: '', is_global: true, virt_assoc_key: :anthropology}]
# holds categories for reuse for variable fields
variable_field_categories = { }

vfcs.each do |vfc|
  begin
    variable_field_categories[vfc[:virt_assoc_key]] = VariableFieldCategory.new(vfc.except(:virt_assoc_key))
    variable_field_categories[vfc[:virt_assoc_key]].save!
    puts "INFO: Kategorie metriky [#{vfc[:name]}] úspěšně přidána.\n"
  rescue Exception => e
    puts "ERROR: Během přidávání kategorie metriky [#{vfc[:name]}] došlo k následující chybě: #{e.message}\n"
  end
end

# VARIABLE FIELDS =====================================================================================================
vfs = [{name: '60 metrů - dráha', description: '', unit: 's', higher_is_better: false, is_numeric: true, is_global: true, vfc_key: :speed},
      {name: '100 metrů - dráha', description: '', unit: 's', higher_is_better: false, is_numeric: true, is_global: true, vfc_key: :speed},
      {name: '200 metrů - dráha', description: '', unit: 's', higher_is_better: false, is_numeric: true, is_global: true, vfc_key: :speed},
      {name: 'Kliky', description: '', unit: '', higher_is_better: true, is_numeric: true, is_global: true, vfc_key: :strength},
      {name: 'Klasický shyby', description: '', unit: 's', higher_is_better: false, is_numeric: true, is_global: true, vfc_key: :strength},
      {name: 'Přeskoky přes švihadlo 1 min', description: '', unit: '', higher_is_better: true, is_numeric: true, is_global: true, vfc_key: :coordination},

      # tennis specific
      {
          name: 'Člunkový běh - tenisové hřiště',
          description:'Klasické tenisové cvičení pro testování rychlosti a koordinace. Sběr 5 tenisových míčků rozmístěných' +
              ' po obvodu zadního pole.',
          unit: 's',
          higher_is_better: false,
          is_numeric: true,
          is_global: true,
          vfc_key: :speed
      },
      {
          name: 'Podání spodem',
          description: 'Podává se ze základní čáry do servis pole dle pravidel tenisu. Je k dispozici 10 pokusů. ' +
              'Počítají se pouze úspěšná podání.',
          unit: '',
          higher_is_better: true,
          is_numeric: true,
          is_global: true,
          vfc_key: :coordination
      },
      {
          name: 'Podání vrchem',
          description: 'Podává se ze základní čáry do servis pole dle pravidel tenisu. Je k dispozici 10 pokusů. ' +
              'Počítají se pouze úspěšná podání.',
          unit: '',
          higher_is_better: true,
          is_numeric: true,
          is_global: true,
          vfc_key: :coordination
      }
]

vfs.each do |vf|
  begin
    v = VariableField.new(vf.except(:vfc_key))
    v.variable_field_category = variable_field_categories[vf[:vfc_key]]
    v.save!
    puts "INFO: Metrika [#{vf[:name]}] úspěšně přidána.\n"
  rescue Exception => e
    puts "ERROR: Během přidávání metriky [#{vf[:name]}] došlo k následující chybě: #{e.message}\n"
  end
end