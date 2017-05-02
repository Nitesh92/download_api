defmodule DownloadApiTest do
  use ExUnit.Case
  #doctest DownloadApi
  #import DownloadApiTest.PMap
  #import DownloadApitest

  test "file should have four column" do
    file = File.stream!("/home/nitesh/grnconnect/data/gta/gta_city_airport.tsv", [:write, :utf8])
    assert DownloadApitest.no_of_column(file)
  end


end
