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
  Colonne da esportare

  ## Examples
      iex> Ehiscen.HisCsvfromOracle.colonne_export()
      []
  """
  def colonne_export, do: ~w(cod_staz cod_grand data_mis valore)

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
  Imposta i parametri per leggere file ".csv" il delimitatore è ";"
  -> restituisce i parametri

  Header del file esportato da Oracle

  ## Examples
      iex> Ehiscen.HisCsvfromOracle.set_parametri_lettura_csv("nome_file.csv", header_types(), 100)

  """

  def set_parametri_lettura_csv(file, intestazione \\ header_types(), max_rows \\ @max_rows) do
    opts = [delimiter: ";", max_rows: max_rows, header: false, dtypes: intestazione]
    {file, opts}
  end

  @doc """
  Legge un file ".csv"  -> restituisce un DataFrame

  parametri è una tuple {file, opts}

  ## Examples
      iex> Ehiscen.HisCsvfromOracle.leggi_csv(parametri)

  """
  def leggi_csv({file, opts} = parametri) do
    IO.puts(parametri)
    DF.from_csv!(file, opts)
  end

  def add__data_time_e_data_mis(df) do
    df0 = DF.mutate(df, date_time: Explorer.Series.strptime(data_ita, "%d-%m-%Y %H:%M"))
    DF.mutate(df0, data_mis: Explorer.Series.strftime(date_time, "%Y-%m-%dT%H:%MZ"))
  end

  def seleziona_colonne_nel_dataframe(df, selezione \\ colonne_export()) do
    DF.select(df, selezione)
  end

  def leggi_csv_e_trasforma({file, opts}) do
    DF.from_csv!(file, opts)
    |> add__data_time_e_data_mis()
    |> seleziona_colonne_nel_dataframe()
  end
end
