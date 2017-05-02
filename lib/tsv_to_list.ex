defmodule TSVToList do

  def get_list do
    file = File.stream!("/home/nitesh/grnconnect/data/gta/gta_city_master.tsv")
    tsv_file = File.open!("/home/nitesh/grnconnect/data/gta/gta_city_code.tsv", [:write, :utf8])

    file|> Enum.map(fn line ->
          line
          |> String.strip
          |> String.split("\t")
          |> List.first
          |> String.split("-")
          |> Enum.at(1)
          |> CSV.encode
          #|> Enum.each(&IO.write(tsv_file, &1))
         end)
  end

end
