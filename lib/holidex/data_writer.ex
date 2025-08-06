defmodule Holidex.DataWriter do
  def json_io(structure) do
    structure |> JSON.encode_to_iodata!()
  end

  def to_file(io_data) do
    {:ok, path} = Path.safe_relative("output/file.json", File.cwd!())
    File.write!(path, io_data)
  end
end
