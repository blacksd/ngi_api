require 'spec_helper'

describe NgiAPI do
	context 'when in test mode' do
		
		before :all do
	    	@myNgiAPI = NgiAPI.new({test: true})
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
			it 'is fine with a dot separated single mac' do 
				expect(@myNgiAPI.infoRadio('00.aA.bB.cC.dD.11')[:info][:"@xsi:type"]).to eq("ns1:radioInfoListType")
			end
			it 'is fine with a colon divided single mac' do 
				expect(@myNgiAPI.infoRadio('00:aA:bB:cC:dD:11')[:info][:"@xsi:type"]).to eq("ns1:radioInfoListType")
			end
			it 'is fine with a dashed single mac' do 
				expect(@myNgiAPI.infoRadio('00-aA-bB-cC-dD-11')[:info][:"@xsi:type"]).to eq("ns1:radioInfoListType")
			end
			it 'is fine with an unspaced single mac' do 
				expect(@myNgiAPI.infoRadio('00aAbBcCdD11')[:info][:"@xsi:type"]).to eq("ns1:radioInfoListType")
			end
			it 'is fine with a mixed separated single mac' do 
				expect(@myNgiAPI.infoRadio('00aA:bB.cC-dD-11')[:info][:"@xsi:type"]).to eq("ns1:radioInfoListType")
			end
			it 'is okay with a single lowercase login' do
				expect(@myNgiAPI.infoRadio('w12345678901')[:info][:"@xsi:type"]).to eq("ns1:radioInfoListType")
			end
			it 'is okay with a single uppercase login' do
				expect(@myNgiAPI.infoRadio('W12345678901')[:info][:"@xsi:type"]).to eq("ns1:radioInfoListType")
			end
			it 'is fine with an array of mixed values' do
				test_array = [
					'00.aA.bB.cC.dD.11',
					'00-aA-bB-cC-dD-11',
					'00aAbBcCdD11',
					'00aA:bB.cC-dD-11',
					'w12345678901',
					'W12345678901'
				]
				expect(@myNgiAPI.infoRadio(test_array)[:info][:"@xsi:type"]).to eq("ns1:radioInfoListType")
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
				expect{ @myNgiAPI.infoRadio('000000000000') }.to raise_error
				expect{ @myNgiAPI.infoRadio('00.00.00.00.00.00') }.to raise_error
				expect{ @myNgiAPI.infoRadio('00:00:00:00:00:00') }.to raise_error
				expect{ @myNgiAPI.infoRadio('00-00-00-00-00-00') }.to raise_error
				expect{ @myNgiAPI.infoRadio('000000:00.00-00') }.to raise_error
			end
			it 'fails with a login value of W00000000000' do
				expect{ @myNgiAPI.infoRadio('W00000000000') }.to raise_error
				expect{ @myNgiAPI.infoRadio('w00000000000') }.to raise_error
			end

		end

		describe '#infoBts' do
			# OKs
			it 'returns sample data with a numeric param' do
				expect( @myNgiAPI.infoBts(3)[:info_bts][:"@xsi:type"] ).to eq("ns1:BtsFullInfoType")
			end

			it 'returns sample data with a numeric string param' do
				expect( @myNgiAPI.infoBts("3")[:info_bts][:"@xsi:type"] ).to eq("ns1:BtsFullInfoType")
			end

			# KOs
			it 'throws an error with btsId < 1' do
				expect{ @myNgiAPI.infoBts(0) }.to raise_error(ArgumentError)
				expect{ @myNgiAPI.infoBts('0') }.to raise_error(ArgumentError)
			end

		end

		describe '#infoCoverage' do

		end

		describe '#listComuni' do

		end

		describe '#setEthernet' do

		end

		describe '#rebootRadio' do
			# OKs
			it 'returns true'

			# KOs
			it 'throws an error if mac address is invalid'			
			it 'returns an error if mac is all 0s or all 1s'
		end
	end



#  subject { NgiApi.new }

#  describe '#process' do
#    let(:input) { 'My grandmom gave me a sweater for Christmas.' }
#    let(:output) { subject.process(input) }

#    it 'converts to lowercase' do
#      expect(output.downcase).to eq output
#    end

#    it 'combines nouns with doge adjectives' do
#      expect(output).to match /so grandmom\./i
#      expect(output).to match /such sweater\./i
#      expect(output).to match /very christmas\./i
#    end

#    it 'always appends "wow."' do
#      expect(output).to end_with 'wow.'
#    end
#  end

end