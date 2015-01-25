# encoding: utf-8
load ('test_class.rb')
=begin

api_config_fake = { 
    partnerLogin: "asdasd12345", 
    partnerPassword: "asdasdhbi8asd78972ui" 
}
myNgiAccess = NgiAPI.new(api_config_fake)

api_config_test = { test: true }
myNgiAccess = NgiAPI.new(api_config_test)

puts myNgiAccess.operations
puts myNgiAccess.listBts
puts myNgiAccess.infoBts(1)
puts myNgiAccess.listComuni("Lòp")
puts myNgiAccess.setEthernet("00-00-00000000",false)

# this will rise an exception, as per specs
begin
    puts myNgiAccess.setEthernet("11-11-11-11-11-11",true)   
rescue Exception => e
    puts "Damn! Got an exception: #{e}"
end

puts myNgiAccess.rebootRadio("aa-bb-cc-dd-ee-11")

# this will rise an exception, as per specs
begin
    puts myNgiAccess.rebootRadio("111111111111")
rescue Exception => e
    puts "Damn! Got an exception, should be an internal server error: #{e}"
end

# this will trigger an ArgumentError
begin
    api_config_err = { test: true, partnerLogin: "asdasd12345", partnerPassword: "asdasdhbi8asd78972ui" } 
    myNgiAccess_err = NgiAPI.new(api_config_err) 
rescue Exception => e
    puts "Damn! Got an exception, should be an invalid API initialization: #{e}"
end

# this will trigger an ArgumentError
begin
    api_config_err2 = { partnerLogin: "asdasd12345" } 
    myNgiAccess_err2 = NgiAPI.new(api_config_err2) 
rescue Exception => e
    puts "Damn! Got an exception, should be an invalid API initialization: #{e}"
end


# this will trigger an ArgumentError
begin
    puts myNgiAccess.infoRadio(["aa.bb.cc.dd.ee.ff","W12345678901"])
rescue Exception => e
    puts "Damn! Got an exception, should be an invalid mix: #{e}"
end

=end

api_config_test = { test:true }
myNgiAccess = NgiAPI.new(api_config_test)

# puts myNgiAccess.operations
# puts myNgiAccess.infoRadio(["000000000000","aa11bb22cc33"])
puts myNgiAccess.infoRadio(["W00001200000","00:ee:aa:bb:cc:dd","W12345678901","W09898778766"]) 
# {:info=>{:radio_info_list=>[{:client_login=>{:"@xsi:type"=>"xsd:string"}, :mac_address=>"00EEAABBCCDD", :snr_up=>"1", :snr_down=>"2", :distanza=>"13.17", :stato_ethernet=>"1", :bts_id=>"2", :nome_cella=>nil, :tipo_radio=>nil, :"@xsi:type"=>"ns1:radioInfoType"}, {:client_login=>"W00000000001", :mac_address=>"000000000001", :snr_up=>"1", :snr_down=>"2", :distanza=>"13.17", :stato_ethernet=>"1", :bts_id=>"2", :nome_cella=>nil, :tipo_radio=>nil, :"@xsi:type"=>"ns1:radioInfoType"}], :"@xsi:type"=>"ns1:radioInfoListType"}} 

puts myNgiAccess.listBts 
# {:lista_bts=>{:items=>[{:bts_id=>"1", :nome_bts=>"1 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"2", :nome_bts=>"2 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"3", :nome_bts=>"3 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"4", :nome_bts=>"4 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"5", :nome_bts=>"5 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"6", :nome_bts=>"6 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"7", :nome_bts=>"7 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"8", :nome_bts=>"8 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"9", :nome_bts=>"9 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"10", :nome_bts=>"10 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"11", :nome_bts=>"11 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"12", :nome_bts=>"12 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"13", :nome_bts=>"13 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"14", :nome_bts=>"14 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"15", :nome_bts=>"15 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"16", :nome_bts=>"16 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"17", :nome_bts=>"17 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}, {:bts_id=>"18", :nome_bts=>"18 of 18: 12345678-a9f1870699c64a453757842d645e36ea", :lat=>"45.8", :lng=>"8.45", :attiva=>false, :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsInfoType"}], :"@xsi:type"=>"ns1:BtsListType"}} 

puts myNgiAccess.listComuni("Peppinaio") 
# {:lista_comuni=>{:items=>[{:comune=>"Alagna", :istat=>"18001", :provincia=>"PV", :"@xsi:type"=>"ns1:comuneType"}, {:comune=>"Alpignano", :istat=>"1008", :provincia=>"TO", :"@xsi:type"=>"ns1:comuneType"}, {:comune=>"Montorio al Vomano", :istat=>"67028", :provincia=>"TE", :"@xsi:type"=>"ns1:comuneType"}, {:comune=>"Roio del Sangro", :istat=>"69077", :provincia=>"CH", :"@xsi:type"=>"ns1:comuneType"}, {:comune=>"Varano de' Melegari", :istat=>"34045", :provincia=>"PR", :"@xsi:type"=>"ns1:comuneType"}, {:comune=>"Voghera", :istat=>"18182", :provincia=>"PV", :"@xsi:type"=>"ns1:comuneType"}, {:comune=>"Zoppola", :istat=>"93051", :provincia=>"PN", :"@xsi:type"=>"ns1:comuneType"}], :"@xsi:type"=>"ns1:comuneListType"}} 

puts myNgiAccess.rebootRadio("00eeaabbccdd")  
# {:esito=>true} 

puts myNgiAccess.infoBts(3) 
# {:info_bts=>{:bts_id=>"3", :nome_bts=>"il nome \u00E8: 12345678, 3, bb5fa1323d296928d1a4c2ae5a908f70", :lat=>"45.9", :lng=>"8.15", :asl=>"99", :attiva=>true, :data_attivazione=>#<Date: 2015-01-08 ((2457031j,0s,0n),+0s,2299161j)>, :file_mappa=>"mappa.file", :inf_sx_lat=>"45.79585", :inf_sx_lng=>"7.873442", :sup_dx_lat=>"46.15581", :sup_dx_lng=>"8.391391", :tech_string=>{:"@xsi:type"=>"ns1:nonNullName"}, :"@xsi:type"=>"ns1:BtsFullInfoType"}} 

puts myNgiAccess.setEthernet("00aabbccddee",true) 
# {:stato_ethernet=>true} 


