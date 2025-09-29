defmodule Ehiscen.HisCsvfromOracle do
  @moduledoc """
  Documentazione per `Ehiscen.HisCsvfromOracle`.

  Modulo specializzato nella lettura dei file csv esportati da Oracle

  Sono file senza intestazione

  Vedi la funzione `header_types` per vedere le colonne

  """

  require Explorer.DataFrame, as: DF
  # require Explorer.Series, as: DS

  @max_rows 100_000_000_000_000_000

  def grandezze, do: ~w(LIT P1H TCI DVI QIT RGI UCI VAI)

  def colonne, do: ~w(cod_staz cod_grand data_mis valore cod_valid liv_validaz rete)

  @doc """
  Header del file esportato da Oracle

  ## Examples
      iex> Ehiscen.HisCsvfromOracle.header_types()
      [
      {"cod_staz", :string},
      {"cod_grand", :string},
      {"data_ita", :string},
      {"valore", :float},
      {"cod_valid", :integer},
      {"liv_validaz", :integer},
      {"rete", :string}
    ]
  """

  def header_types do
    # in csv 2020 sono presenti delle "A" come liv_validaz (column_6)
    #  {"column_5", :integer}, codici validi solo 0(ok) 4(-99.9 dati non validi ma inclusi in mongodb)
    [
      {"cod_staz", :string},
      {"cod_grand", :string},
      {"data_ita", :string},
      {"valore", :float},
      {"cod_valid", :integer},
      {"liv_validaz", :integer},
      {"rete", :string}
    ]
  end

  @doc """
  Legge un file ".csv" il delimitatore è ";" -> restituisce un DataFrame

  Header del file esportato da Oracle

  ## Examples
      iex> Ehiscen.HisCsvfromOracle.leggi_csv("nome_file.csv", header_types(), 100)

  """

  def leggi_csv(file, intestazione \\ header_types(), max_rows \\ @max_rows) do
    opts = [delimiter: ";", max_rows: max_rows, header: false, dtypes: intestazione]

    DF.from_csv!(file, opts)
    |> plug_add_data_usa(:data_anno_mm_gg_T)
  end

  defp plug_add_data_usa(df, :data_anno_mm_gg_T) do
    df0 = DF.mutate(df, date_time: Explorer.Series.strptime(data_ita, "%d-%m-%Y %H:%M"))
    df1 = DF.mutate(df0, data_mis: Explorer.Series.strftime(date_time, "%Y-%m-%dT%H:%MZ"))
    df1
    # dfinale = DF.discard(df1, ["data_ita", "date_time"])
  end

  def estrai_anno_ita(stringa) do
    _formato = "GG-MM-ANNO HH:MM"
    _stringa = "31-01-2023 00:00"

    String.split(stringa, " ")
    |> hd
    |> String.split("-")
    |> List.last()
    |> String.to_integer()
  end
end
