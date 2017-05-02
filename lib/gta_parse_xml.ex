defmodule GTAParseXml do
  import SweetXml

    def get_airport do
      tsv_file = "gta_city_airport"
      dir_name = "city_Airport"
      val_type = "Airport"
      load_all_data(tsv_file, dir_name, val_type)

      #file = File.stream!("/home/nitesh/grnconnect/data/gta/#{tsv_file}.tsv", [:write, :utf8])
      #no_of_column(file)
    end

    def get_station do
      tsv_file = "gta_city_station"
      dir_name = "city_Station"
      val_type = "Station"
      load_all_data(tsv_file, dir_name, val_type)
    end

    def get_transfer do
      tsv_file = "gta_city_transfer"
      dir_name = "city_Transfer"
      val_type = "Item"
      load_all_data(tsv_file, dir_name, val_type)
    end

    defp load_all_data(tsv_file, dir_name, val_type) do
      file = File.open!("/home/nitesh/grnconnect/data/gta/#{tsv_file}.tsv", [:write, :utf8])
      all_file = Path.wildcard("/home/nitesh/grnconnect/data/gta/#{dir_name}/*.xml")

      all_file
      |> Task.async_stream(&parse_data(&1, val_type), max_concurrency: 3, timeout: :infinity)
      |> Enum.flat_map(fn {:ok, data} -> data end)
      |> CSV.encode(separator:  ?\t)
      |> Enum.each(&IO.write(file, &1))
    end

    defp parse_data(filename, val_type) do
      IO.puts("loading #{filename}")

      filename
      |> File.read!
      |> parse
      |> xmap(airportInfo: [
           ~x".//ResponseDetails/Search#{val_type}Response/#{val_type}Details/#{val_type}Detail"l,
           ct_name: ~x"./City/text()"s,
           ct_code: ~x"./City/@Code"s,
           air_code:  ~x"./#{val_type}/@Code"s,
           air_name: ~x"./#{val_type}/text()"
       ])
      |> Map.get(:airportInfo)
      |> Enum.flat_map(fn airport ->
          [[airport.ct_name, airport.ct_code, airport.air_code, airport.air_name]]
        end)

    end

end
