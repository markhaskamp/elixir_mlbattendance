defmodule Util do

  def slurp(file) do
    case File.read(file) do
      {:ok, body} -> String.split(body, "\n")
      {:error, reason} -> IO.puts("=== #{reason}")
    end
  end

  def pmap(collection, fun) do
    me = self

    collection
    |>
    Enum.map(fn (elem) ->
      spawn_link fn -> (send me, {self, fun.(elem) }) end 
    end)
    |>
    Enum.map(fn (pid) ->
      receive do { ^pid, result } -> result end
    end)
  end

  def pmap2(collection, fun) do

    collection
    |>
    Enum.map(&(Task.async(fn -> fun.(&1) end)))
    |>
    Enum.map(&(Task.await(&1)))
  end


end
