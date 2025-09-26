defmodule Ehiscen.HisCsvfromOracle do
  @moduledoc """
  Documentation for `Ehiscen.HisCsvfromOracle`.

  Modulo specializzato nella lettura dei file csv esportati da Oracle

  Sono file senza intestazione

  Vedi la funzione `rinomina_colonne_map` per vedere le colonne

  """

  require Explorer.DataFrame, as: DF
  # require Explorer.Series, as: DS

  def grandezze, do: ~w(cod_staz)

  def colonne, do: ~w(cod_staz cod_grand data_mis valore cod_valid liv_validaz rete)

  def dtypes do
    # in csv 2020 sono presenti delle "A" come liv_validaz (column_6)
    #  {"column_5", :integer}, codici validi solo 0(ok) 4(-99.9 dati non validi ma inclusi in mongodb)

    [
      {"column_1", :string},
      {"column_2", :string},
      {"column_3", :string},
      {"column_4", :float},
      {"column_5", :integer},
      {"column_6", :integer},
      {"column_7", :string}
    ]
  end

  @doc """
  RinominaColonneMap

  ## Examples

      iex> Ehiscen.HisCsvfromOracle.rinomina_colonne_map()
      %{
        "column_1" => "cod_staz",
        "column_2" => "cod_grand",
        "column_3" => "data_ita",
        "column_4" => "valore",
        "column_5" => "cod_valid",
        "column_6" => "liv_validaz",
        "column_7" => "rete"
      }

  """

  def rinomina_colonne_map do
    %{
      "column_1" => "cod_staz",
      "column_2" => "cod_grand",
      "column_3" => "data_ita",
      "column_4" => "valore",
      "column_5" => "cod_valid",
      "column_6" => "liv_validaz",
      "column_7" => "rete"
    }
  end

  def leggi_DF(file) do
    max_rows = 100_000_000_000_000
    _max_rows = 100
    opts = [delimiter: ";", max_rows: max_rows, header: false, dtypes: dtypes()]

    df = DF.from_csv!(file, opts)
    DF.rename(df, rinomina_colonne_map())
  end
end
