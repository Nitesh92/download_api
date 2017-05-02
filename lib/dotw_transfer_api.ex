defmodule DOTWTransfersAPI do
  HTTPoison.start
  use HTTPoison.Base
  import SweetXml

  @endpoint "http://xmldev.dotwconnect.com/gatewayV3.dotw"

  def get_city_list do
      file = File.read!("/home/nitesh/grnconnect/data/dotw/dotw_city_master.xml")

      file
      |> parse
      |> xmap(cityCode: [
           ~x".//cities/city"l,
           ct_code: ~x"./code/text()"s
       ])
      |> Map.get(:cityCode)
      |> Enum.flat_map(fn ccode ->
          [[ccode.ct_code]]
        end)
      |> get_transfer_city

  end

  defp get_transfer_city(city_code) do
    for city_code <- city_code, do: (
      body =  "<customer><username>chakrapani</username><password>92c892dab199dd51fafbfee5aa6a09eb</password><id>1220708</id><source>1</source><product>transfer</product><request command=\"searchtransfers\"><bookingDetails><fromDate>2017-04-28</fromDate><startingTime>1224</startingTime><pickUpFrom>746</pickUpFrom><dropOffTo>747</dropOffTo><currency>520</currency><transfers><adults>1</adults><children no=\"0\"></children></transfers></bookingDetails><return><filters xmlns:a=\"http://us.dotwconnect.com/xsd/atomicCondition_transfers\" xmlns:c=\"http://us.dotwconnect.com/xsd/complexCondition_transfers\"> <city>#{city_code}</city><noPrice>true</noPrice><showFilters>true</showFilters></filters><fields><field>description</field><field>transferName</field><field>images</field><field>language</field><field>optionalLanguages</field><field>meetingPoint</field><field>duration</field><field>pickUp</field><field>dropOff</field><field>cityName</field><field>cityCode</field><field>stateName</field><field>stateCode</field><field>countryName</field><field>countryCode</field><field>transferType</field><field>ac</field><field>language</field></fields></return></request></customer>"

      request_data(body, city_code)
    )
  end

  defp request_data(body, city_code) do
    IO.puts("saving #{city_code}.xml")

    temp = HTTPoison.request!(:post, @endpoint, body, [{"Content-Type", "text/xml"}], [recv_timeout: 20000])
    content = temp.body
    File.write!("/home/nitesh/grnconnect/data/dotw/city_Transfer/#{city_code}.xml", content, [])
  end

end
