alias Ehiscen, as: EH

alias Ehiscen.HisCsvfromOracle, as: CsvOracle

my_dir = System.get_env("WINDOWS_SHARE")
dir_dati_esempio = Path.join(my_dir, "poa/EXPORT_PTI_SASSARI_NEW")

csv_files = Path.wildcard(Path.join(dir_dati_esempio, "*.csv"))
