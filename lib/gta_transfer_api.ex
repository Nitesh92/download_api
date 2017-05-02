defmodule GTATransferApi do
  HTTPoison.start
  use HTTPoison.Base

  @endpoint "https://interface.demo.gta-travel.com/wbsapi/RequestListenerServlet"

      def get_airport(city_code) do
        val_type = "Airport"
        get_request(city_code, val_type)
      end

      def get_station(city_code) do
        val_type = "Station"
        get_request(city_code, val_type)
      end

      def get_transfer(city_code) do
        val_type = "Item"
        get_request_trns(city_code, val_type)
      end

      defp get_request(city_code, val_type) do
        for city_code <- city_code, do: (
          body = "<Request><Source><RequestorID Client='1939' EMailAddress='XML.AZRI@AMANTRAVELS.COM' Password='PASS'/><RequestorPreferences Language='en'><RequestMode>SYNCHRONOUS</RequestMode></RequestorPreferences></Source><RequestDetails><Search#{val_type}Request><ItemDestination DestinationType='city' DestinationCode='#{city_code}' /><#{val_type}Name><![CDATA[at]]></#{val_type}Name></Search#{val_type}Request></RequestDetails></Request>"

          request_data(body, city_code, val_type)
        )
      end

      def get_request_trns(city_code, val_type) do
        for city_code <- city_code, do: (
          body = "<Request><Source><RequestorID Client='1939' EMailAddress='XML.AZRI@AMANTRAVELS.COM' Password='PASS'/><RequestorPreferences Language='en'><RequestMode>SYNCHRONOUS</RequestMode></RequestorPreferences></Source><RequestDetails><Search#{val_type}Request ItemType=\"transfer\"><#{val_type}Destination DestinationType='city' DestinationCode='#{city_code}' /><#{val_type}Name><![CDATA[at]]></#{val_type}Name></Search#{val_type}Request></RequestDetails></Request>"
          val_type = "Transfer"
          request_data(body, city_code, val_type)
        )
      end


      defp request_data(body, city_code, val_type) do
        temp = HTTPoison.request!(:post, @endpoint, body, [{"Content-Type", "application/xml"}], [recv_timeout: 20000])
        content = temp.body
        File.write!("/home/nitesh/grnconnect/data/gta/city_#{val_type}/#{city_code}.xml", content, [])
      end
end
