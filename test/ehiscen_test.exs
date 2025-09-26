defmodule EhiscenTest do
  use ExUnit.Case
  doctest Ehiscen

  test "Author" do
    assert Ehiscen.author() == "Andrea Lai"
  end
end
