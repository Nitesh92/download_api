defmodule DOTWParseXml do
  import SweetXml

      def get_transfers do
        all_files = Path.wildcard("/home/nitesh/grnconnect/data/dotw/city_Transfer/*.xml")

        all_files
        |> Task.async_stream(&parse_data/1, max_concurrency: 3, timeout: :infinity)
        |> save_data
      end

      defp save_data(data) do

        file1 = File.open!("/home/nitesh/grnconnect/data/dotw/data.tsv", [:write, :utf8])
        file2 = File.open!("/home/nitesh/grnconnect/data/dotw/images.tsv", [:write, :utf8])

        for {:ok, each} <- data do
          elem(each, 0) |> CSV.encode(separator: ?\t) |> Enum.each(&IO.write(file1, &1))
          elem(each, 1) |> CSV.encode(separator: ?\t) |> Enum.each(&IO.write(file2, &1))
        end
      end

      defp parse_data(file) do
        IO.puts("Loading #{file}")

        file
        |> File.read!
        |> parse
        |> xmap(transferInfo: [
             ~x"//result/transfers/transfer"l,
                   trans_id: ~x"./@transferid"s,
                   trans_pref: ~x"./@preferred"s,
                   trans_typ: ~x"./transfer/@type"s,
                   ct_code: ~x"./cityCode/text()"s,
                   ct_name: ~x"./cityName/text()"s,
                   trans_name: ~x"./transferName/text()"s,
                   trans_desc: ~x"./description/language/text()"s,
                   meet_pt: ~x"./meetingPoint/text()"s,
                   duration: ~x"./duration/text()"s,
                   pick_up: ~x"./pickUp/text()"s,
                   drop_off: ~x"./dropOff/text()"s,
                   st_code: ~x"./stateCode/text()"s,
                   st_name: ~x"./stateName/text()"s,
                   cnt_code: ~x"./countryCode/text()"s,
                   cnt_name: ~x"./countryName/text()"s,
                   images: [~x"//images/transferImages/image"l,
                              img_url: ~x"./text()"s
                   ]
              ])
          |> Map.get(:transferInfo)
          |> Enum.reduce({[], []}, fn(transfer, acc) ->

                  temp = if transfer.trans_pref == "yes" do
                  "Y"
                  else
                    "N"
                  end

                images = for image <- transfer.images do
                  [transfer.trans_id, image.img_url]
                end

                {[[transfer.ct_code, transfer.ct_name, transfer.trans_id, transfer.trans_name, transfer.trans_desc, temp, transfer.trans_typ, transfer.meet_pt, transfer.duration, transfer.pick_up, transfer.drop_off, transfer.st_code, transfer.st_name, transfer.cnt_code, transfer.cnt_name] | elem(acc, 0)],
                images ++ elem(acc, 1)}

          end)
        end

end
