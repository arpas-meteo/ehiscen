defmodule Mix.Tasks.Ehiscen do
  use Mix.Task

  @shortdoc "Gestione versione Ehiscen"

  @moduledoc """
  Prints Ehiscen tasks and their information.
      $ mix Ehiscen
  To print the Ehiscen version, pass `-v` or `--version`, for example:
      $ mix Ehiscen --version
  """

  @version Mix.Project.config()[:version]

  @impl true
  @doc false
  def run([opzione]) when opzione in ~w(-v --version) do
    Mix.shell().info("Ehiscen v#{@version}")
  end

  @impl true
  @doc """
  Legge la versione da mix.exs e la cambia in:
  README.md
  VERSION
  """
  def run([opzione]) when opzione in ~w(-awv --allinea) do
    old = File.read!("VERSION")
    new_version = "v#{@version}"
    File.write!("VERSION", new_version)
    modifica_readme(old)
    Mix.shell().info("VERSION era #{old} -> Ehiscen #{new_version}")
  end

  @impl true
  @doc false
  def run([opzione]) when opzione in ~w(-a --app) do
    Mix.shell().info("App Ehiscen v#{@version}")
  end

  def run(args) do
    case args do
      [] -> general()
      _ -> Mix.raise("Invalid arguments, expected: mix Ehiscen")
    end
  end

  defp general() do
    Application.ensure_all_started(:Ehiscen)
    Mix.shell().info("Gestione versione")
    Mix.shell().info("Ehiscen v#{Application.spec(:Ehiscen, :vsn)}")
    Mix.shell().info("\n## Options\n")
    Mix.shell().info("-v, --version # Ehiscen version\n")
    Mix.shell().info("-awv          # Allinea la versione in più file\n")
    Mix.Tasks.Help.run(["--search", "Ehiscen."])
  end

  defp modifica_readme(da_version) do
    v_elimnata = String.slice(da_version, 1, 50)
    IO.inspect(v_elimnata, label: "v_eliminata")
    con_readme = File.read!("README.md")
    new_version = String.replace(con_readme, v_elimnata, @version)
    File.write!("README.md", new_version)
    Mix.shell().info("Modificato README.md")
  end
end
