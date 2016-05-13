defmodule Mobilizer.Writer do
  @doc """
  Get the contents from a file.
  """
  def get_contents_from_file(file), do: File.read file
end
