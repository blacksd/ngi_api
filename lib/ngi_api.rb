# encoding: utf-8

require "digest"
# gem "rubyntlm", "~> 0.3.2"
require "rubyntlm"
require "savon"
require "net/http"

# This class is a convenient, easy way to access
# the APIs provided by NGI without manually having
# to build and submit SOAP requests. There are 
# multiple built-in checks for type corrections, and
# the entered values are automatically adjusted.
#
# Author::    Marco Bulgarini  (mailto:marco.bulgarini@com-net.it)
# Copyright:: Copyright (c) 2015 Com Net S.a.s.
# License::   Distributes under the same terms as Ruby

# This is the main class, holding all of the functions
# and checks. The instance it's built with a hash of arguments.
class NgiAPI

    # call-seq:
    #   MyNGIAccess = NgiAPI.new(arguments)    
    #  
    #
    # Initialize the class instance with a hash of arguments. The hash is mandatory and must not be empty.
    # There's a test mode and a production live mode.
    # == Test mode
    #   arguments[:test] = true
    # Puts any operation in test mode, with standard login and password and a different wsdl.
    #   arguments[:debug] = true 
    # The :debug can be set to true for improved stdout logging.
    # == Production mode
    #   arguments[:partnerLogin] = "13243546"
    #   arguments[:partnerPassword] = "randomsaltprovidedbyNGI"
    # 
	def initialize(args)
        raise ArgumentError, "no arguments provided, no idea what to do" if args.empty?
        raise ArgumentError, "\"test\" option provided with login and/or password - can't do that" if args[:test] && (!!args[:partnerLogin] || !!args[:partnerPassword])
        raise ArgumentError, "you must give both a login and a password." if !!args[:partnerLogin] ^ !!args[:partnerPassword]
		@partnerLogin = !!args[:test] ? "12345678" : parameter_to_string(args[:partnerLogin])
		@partnerPassword = !!args[:test] ? "517fc7b578767ebfa6bb5252252653d2" : parameter_to_string(args[:partnerPassword])
        fetch_cacert unless File.exist?('cacert.pem')
        @soapClient = Savon.client do
          wsdl !!args[:test] ? "https://www.eolo.it/ws/wsdl/?test" : "https://www.eolo.it/ws/wsdl"
          ssl_ca_cert_file "cacert.pem"
          if args[:debug]
            log true 
            log_level :debug 
            pretty_print_xml true
          end
        end
	end

    # --------------------------------------
    # :section: Available Operations
    # As Public Instance Methods are the operations available through NGI APIs.
    # Make good use of them, and don't abuse.
    # --------------------------------------

    # call-seq:
    #   MyNGIAccess.infoRadio(macAddresses_clientLogins) => {...}    
    #  
    # Status of a radio, obtained as a string or an array of a client login/mac address.
    def infoRadio(macAddresses_clientLogins)
        
        macAddressArray = []
        clientLoginArray = []

        case macAddresses_clientLogins.class.to_s
        when "Array"
            raise ArgumentError,"array exceeds 20 elements" if macAddresses_clientLogins.size > 20
            macAddresses_clientLogins.each_with_index do |element,index|
                    raise ArgumentError, "value #{element} at position #{index} is not a valid mac address or a login" unless is_valid_mac(element) || is_valid_login(element)
                    macAddressArray.push(fix_mac_address(element)) if is_valid_mac(element)
                    clientLoginArray.push(fix_login(element)) if is_valid_login(element)
            end
        when "String"
            raise ArgumentError,"the single value to check is not a valid mac address or customer login" unless is_valid_mac(macAddresses_clientLogins) || is_valid_login(macAddresses_clientLogins)
            macAddressArray.push(fix_mac_address(macAddresses_clientLogins)) if is_valid_mac(macAddresses_clientLogins)
            clientLoginArray.push(fix_login(macAddresses_clientLogins)) if is_valid_login(macAddresses_clientLogins)
        else
            raise ArgumentError,"unsupported data type: a single mac address or login string or an array of them are the only allowed types."
        end 
        
        build_and_send_query(:info_radio,
            {
                macAddressList: macAddressArray,
                clientLoginList: clientLoginArray
            }
        )
    end

    # call-seq:
    #   MyNGIAccess.infoBts(btsID) => {...}    
    #  
    # Obtain the exact informations about a specific BTS. btsID is a non-negative integer.
    def infoBts(btsID)
        raise ArgumentError, "btsID value not allowed" unless btsID.to_i > 0 && btsID.class.to_s == "Fixnum"
        build_and_send_query(:info_bts,
            {
                btsID: parameter_to_string(btsID)
            }
        )
    end

    # call-seq:
    #   MyNGIAccess.infoCoverage(via,civico,istat) => {...}    
    #  
    # Gets the coverage for the specified address. The address is composed of
    # * +via+ the street location
    # * +civico+ the number
    # * +istat+ the istat code for the town, gathered from listComuni
    def infoCoverage(via,civico,istat)
        build_and_send_query(:info_coverage, 
            {
                via: parameter_to_string(via), 
                civico: parameter_to_string(civico), 
                istat: parameter_to_string(istat)
            }
        )
    end

    # call-seq:
    #   MyNGIAccess.listBts => {}    
    #  
    # Obtain a hash of active BTSes with their details. No input needed, lots of output to be expected.
    def listBts
        build_and_send_query(:list_bts)
    end

    # call-seq:
    #   MyNGIAccess.listComuni(comune) => {}    
    #  
    # Obtain the istat code for the town.
    def listComuni(comune)
        raise ArgumentError, "comune is not >=2 and <= 35 in length, or has not allowed characters" unless is_valid_comune(parameter_to_string(comune))
        build_and_send_query(:list_comuni,
            {
                comune: parameter_to_string(comune)
            }
        )
    end
    
    # call-seq:
    #   MyNGIAccess.setEthernet(macAddress,statoEthernet) => {:stato_ethernet=>true}     
    #  
    # Set the ethernet adapter of a customer's radio.
    def setEthernet(macAddress,statoEthernet)
        raise ArgumentError, "specified mac address is wrong or in an invalid format" unless is_valid_mac(macAddress)
        raise ArgumentError, "stato ethernet is wrong on in an invalid format" unless ["0","1"].include? parameter_to_string(statoEthernet)
        build_and_send_query(:set_ethernet,
            {
                macAddress: fix_mac_address(parameter_to_string(macAddress)),
                statoEthernet: parameter_to_string(statoEthernet)
            }
        )
    end

    # call-seq:
    #   MyNGIAccess.rebootRadio(macAddress) => {esito: true}    
    #  
    # Reboot a customer's radio.
    def rebootRadio(macAddress)
        raise ArgumentError, "specified mac address is wrong or in an invalid format" unless is_valid_mac(macAddress)
        build_and_send_query(:reboot_radio,
            {
                macAddress: fix_mac_address(parameter_to_string(macAddress))
            }
        )
    end

    private

    # formats the mac address for the request, stripping separators and upcasing it
    def fix_mac_address(mac)
        mac.to_s.gsub(/[\.:-]?/,'').upcase    
    end

    # formats the login for the request, upcasing it 
    def fix_login(login)
        login.upcase
    end

    # Download the 'cacert.pem' file from "curl.haxx.se" if not found in the running directory
    # Courtesy of https://gist.github.com/fnichol/867550
    def fetch_cacert
        Net::HTTP.start("curl.haxx.se") do |http|
            resp = http.get("/ca/cacert.pem")
            if resp.code == "200"
                open("cacert.pem", "wb") do |file|
                    file.write(resp.body)
                end 
            else
                raise "no \"cacert.pem\" file found, and can't download it from curl website"
            end
        end
    end

    # Build and submit the SOAP query.
    # Needed the operation (raise an error if it's not an allowed one from the server) and a hash of optional parameters.
    def build_and_send_query(type,params = {})
        type = type.to_sym
        raise ArgumentError, "query type not included in allowed operations: #{@soapClient.operations}" unless @soapClient.operations.include? type
        
        message = { wsLogin: @partnerLogin }
        checksum = @partnerLogin

        case type
        when :info_bts
            checksum += params[:btsID]
            message[:btsID] = params[:btsID]
        when :list_comuni
            checksum += params[:comune]
            message[:comune] = params[:comune]
        when :set_ethernet
            checksum += params[:macAddress]
            checksum += params[:statoEthernet]
            message[:macAddress] = params[:macAddress]
            message[:statoEthernet] = params[:statoEthernet]
        when :reboot_radio
            checksum += params[:macAddress]
            message[:macAddress] = params[:macAddress]
        when :info_radio
            checksum += parameter_to_string(params[:macAddressList])
            checksum += parameter_to_string(params[:clientLoginList])
            message[:macAddressList] = {items: params[:macAddressList]}
            message[:clientLoginList] = {items: params[:clientLoginList]}
        when :list_bts # no input needed
        end
        
        message[:controlHash] = Digest::MD5.hexdigest(checksum+@partnerPassword)
        @soapClient.call(type, message: message).to_hash[(type.to_s+"_response").to_sym]
    end
    
    # According to {http://unicode-table.com}[http://unicode-table.com]
    # * \u{00E0} à
    # * \u{00E8} è
    # * \u{00E9} é
    # * \u{00EC} ì
    # * \u{00F2} ò
    # * \u{00F9} ù
    def is_valid_comune(comune)
        !!comune.to_s[/^([a-zA-Z\u{00E0}\u{00E8}\u{00E9}\u{00EC}\u{00F2}\u{00F9}]{2}[a-zA-Z\u{0200}\u{0201}\u{0236}\u{0242}\u{0249}]{0,33})$/]
    end

    # Loose check for if a string is a valid login. Value must be formatted before submit with fix_login.
    # Matches "w or W" + 11 digits
    def is_valid_login(login)
        !!login.to_s[/[wW]\d{11}/]
    end

    # Loose check for the validity of a MAC address. Value must be formatted with fix_mac_address before submit.
    # Matches any of the following:
    # * 00aabbccddee
    # * 00-aa-bb-cc-dd-ee
    # * 00:aa:bb:cc:dd:ee
    # * 00.aa.bb.cc.dd.ee
    def is_valid_mac(mac)
        !!mac.to_s[/^([0-9a-fA-F]{2}[\.:-]?){5}([0-9a-fA-F]{2})$/]
    end

    # Formatting types according to NGI API 
    def parameter_to_string(parameter)
        case parameter.class.to_s
        when "TrueClass","FalseClass" 
            parameter ? "1" : "0"
        when "Integer"
            "%d" % parameter
        when "Float"
            "%.5f" % parameter
        when "Array" # streamline it
            parameter.map{ |element| parameter_to_string(element) }.join
        else # for any other type, convert it to a string
            "%s" % parameter.to_s
        end
    end

end

