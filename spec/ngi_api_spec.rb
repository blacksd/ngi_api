# encoding: utf-8

require 'spec_helper'

describe NgiAPI do
	context 'when in test mode' do
		
		before :all do
	    	@myNgiAPI = NgiAPI.new({test: true})
	    	@macstotest = [
	    		# '00.aA.bB.cC.dD.11', 	# dots 
	    		# '00:aA:bB:cC:dD:11',	# colons  
	    		# '00-aA-bB-cC-dD-11',	# dashes
	    		# '00aAbBcCdD11',		# no spaces
	    		'00aA:bB.cC-dD-11'		# mixed
	    	]
	    	@zeroedmacstotest = [
	    		# '00.00.00.00.00.00', 	# dots 
	    		# '00:00:00:00:00:00',	# colons  
	    		# '00-00-00-00-00-00',	# dashes
	    		# '000000000000',		# no spaces
	    		'0000:00.00-00-00'		# mixed
	    	]
	    	@onedmacstotest = [
	    		# '11.11.11.11.11.11', 	# dots 
	    		# '11:11:11:11:11:11',	# colons  
	    		# '11-11-11-11-11-11',	# dashes
	    		# '111111111111',		# no spaces
	    		'1111:11.11-11-11'		# mixed
	    	]
	    	@loginstotest = [
	    		# 'W12345678901'		# upcase
	    		'w12345678901',			# lowcase
	    	]
	    	@zeroedloginstotest = [
	    		# 'W00000000000'		# upcase
	    		'w00000000000',			# lowcase
	    	]
		end

		it 'can build a test instance' do 
			expect(@myNgiAPI).to be_an_instance_of NgiAPI
		end

		describe '#listBts' do
			# OKs
			it 'returns a BtsListType' do
				expect(@myNgiAPI.listBts[:lista_bts][:"@xsi:type"]).to eq("ns1:BtsListType")
			end

			# KOs
			it 'sometimes returns an empty list (1 in 10)' do
				sample = ""
				10.times do
					sample = @myNgiAPI.listBts[:lista_bts][:items]
					break if sample.nil?
				end
				expect(sample).to be_nil
			end
		end

		describe '#infoRadio' do
			# OKs
			it 'is fine with a single mac' do 
				@macstotest.each do |mac|
					expect(@myNgiAPI.infoRadio(mac)[:info][:"@xsi:type"]).to eq("ns1:radioInfoListType")
				end
			end

			it 'is okay with a single login' do
				@loginstotest.each do |login|
					expect(@myNgiAPI.infoRadio(login)[:info][:"@xsi:type"]).to eq("ns1:radioInfoListType")
				end
			end

			it 'is fine with an array of mixed values' do
				(@macstotest + @loginstotest).each do |element|
					expect(@myNgiAPI.infoRadio(element)[:info][:"@xsi:type"]).to eq("ns1:radioInfoListType")
				end
			end 

			# KOs
			it 'fails with a non-mac non-login value' do
				expect{ @myNgiAPI.infoRadio('someinvalidstring') }.to raise_error(ArgumentError)
			end
			it 'fails with a large (> 20) array' do
				large_test_array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22]
				expect{ @myNgiAPI.infoRadio(large_test_array) }.to raise_error(ArgumentError)
			end
			it 'fails with a mac value of 000000000000' do
				@zeroedmacstotest.each do |zeroedmac|
					expect{ @myNgiAPI.infoRadio(zeroedmac) }.to raise_error
				end
			end

			it 'fails with a login value of W00000000000' do
				@zeroedloginstotest.each do |zeroedlogin|
					expect{ @myNgiAPI.infoRadio(zeroedlogin) }.to raise_error
				end
			end

		end

		describe '#infoBts' do
			# OKs
			it 'returns sample data' do
				[
					3,		# int
					"3"		# string
				].each do |bts_input|
					expect( @myNgiAPI.infoBts(bts_input)[:info_bts][:"@xsi:type"] ).to eq("ns1:BtsFullInfoType")
				end
			end

			# KOs
			it 'throws an error with btsId < 1' do
				[
					0,		# int
					"0"		# string
				].each do |bts_input|
					expect{ @myNgiAPI.infoBts(bts_input) }.to raise_error(ArgumentError)
				end
			end

		end

		describe '#infoCoverage' do
			# OKs
			it 'returns a list of matching BTSes for the address' do
				expect( @myNgiAPI.infoCoverage("Viale Monza",12,"12345")[:lista_bts][:"@xsi:type"] ).to eq("ns1:BtsListType")
			end
		end

		describe '#listComuni' do
			# OKs
			it 'returns a list of towns' do
				expect( @myNgiAPI.listComuni("someteststring")[:lista_comuni][:"@xsi:type"] ).to eq("ns1:comuneListType")
			end

			it 'works fine with latin characters' do
				expect( @myNgiAPI.listComuni("sometestàèéìòùstring")[:lista_comuni][:"@xsi:type"] ).to eq("ns1:comuneListType")
			end

			# KOs
			it 'throws an error with a short (<2 chars) param' do
				expect{ @myNgiAPI.listComuni("a") }.to raise_error(ArgumentError)
			end

			it 'throws an error with a long (>35 chars) param' do
				expect{ @myNgiAPI.listComuni("areallylongstringthatshouldnotbeatown") }.to raise_error(ArgumentError)
			end

			it 'returns an empty list with a "nolist" param' do
				expect( @myNgiAPI.listComuni("nolist")[:lista_comuni][:items] ).to be_nil
			end

			it 'throws an error with a "error" param' do
				expect{ @myNgiAPI.listComuni("error") }.to raise_error
			end
		end

		describe '#setEthernet' do
			# OKs
			it 'can enable an ethernet interface' do 
				[
					1,		# int
					true	# bool
				].each do |eth_enable_state|
					@macstotest.each do |mac|
						expect( @myNgiAPI.setEthernet(mac,eth_enable_state)[:stato_ethernet] ).to be true
					end
				end
			end

			it 'can disable an ethernet interface' do
				[
					0,		# int
					false	# bool
				].each do |eth_enable_state|
					@macstotest.each do |mac|
						expect( @myNgiAPI.setEthernet(mac,eth_enable_state)[:stato_ethernet] ).to be false
					end
				end
			end

			# KOs
			it 'throws an error if mac is all 1s' do
				[
					true,	# bool
					false
				].each do |eth_state|
					@onedmacstotest.each do |onedmac|
						expect{ @myNgiAPI.setEthernet(onedmac,eth_state) }.to raise_error
					end
				end
			end
			
			it 'always gets a false with a mac of all 0s' do
				[
					true,	# bool
					false
				].each do |eth_state|
					@zeroedmacstotest.each do |zeroedmac|
						expect( @myNgiAPI.setEthernet(zeroedmac,eth_state)[:stato_ethernet] ).to be false
					end
				end
			end
		end

		describe '#rebootRadio' do
			# OKs
			it 'returns true' do
				@macstotest.each do |mac|
					expect( @myNgiAPI.rebootRadio(mac)[:esito] ).to be true 
				end
			end

			# KOs
			it 'throws an error if mac address is invalid' do
				expect{ @myNgiAPI.rebootRadio('someinvalidstring') }.to raise_error(ArgumentError)			
			end

			it 'returns an error if mac is all 0s or all 1s' do
				(@zeroedmacstotest + @onedmacstotest).each do |mac|
					expect{ @myNgiAPI.rebootRadio(mac) }.to raise_error
				end
			end
		end
	end
end