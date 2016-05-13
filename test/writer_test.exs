defmodule MobilizerTest do
  use ExUnit.Case, async: true

  test "should get the contents of a file" do
    {:ok, contents} = Mobilizer.Writer.get_contents_from_file "test/fixtures/foo.txt"
    assert contents == "foo.foo\n"
  end
end
