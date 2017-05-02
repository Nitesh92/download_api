defmodule DownloadApitest do

  def no_of_column(file) do

    var = file
      |> Enum.map(fn line -> line
      |> String.split("\t")
      |> Enum.count
    end)
    var |> Enum.all?(fn(x) -> x == 4 end)
  end
  
end
