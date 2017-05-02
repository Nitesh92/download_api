defmodule DownloadApi.Mixfile do
  use Mix.Project

  def project do
    [app: :download_api,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: [
       maintainers: ["Frank Liu", "Arnaud Wetzel", "Tomáš Brukner", "Vinícius Sales", "Sean Tan"],
       licenses: ["MIT"],
       links: %{
         "GitHub" => "https://github.com/awetzel/sweet_xml"
       }
     ],
     docs: &docs/0,
     consolidate_protocols: true]
  end

#working

  defp deps do
    [{:httpoison, "~> 0.11.1"},
    {:ex_doc, "~> 0.14.5", only: :dev},
    {:earmark,"~> 1.1.0 ", only: :dev},
    {:csv, "~> 1.4.2"}]
  end

  defp docs do
    {ref, 0} = System.cmd("git", ["rev-parse", "--verify", "--quiet", "HEAD"])
    [
        source_ref: ref,
        main: "overview"
    ]
  end

end
