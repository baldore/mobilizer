defmodule Mobilizer.Scraper do
  def scrap do
    # Initial variables
    page = "http://elespejogotico.blogspot.com.co/2007/11/relatos-y-cuentos-de-lovecraft.html"
    selector = ".post-body li a"

    body = get_page_contents(page)

    links = Floki.find(body, selector)
      |> Enum.map(&anchors_to_keyword_list/1)

    links

    # Next Steps
    # X Convert the links into a list of dictionaries.
    # - Run through each url and get the contents of each story.
    # - Create a new list of dictionaries with the stories and its titles.
    # - Create the book.
    # - Convert to mobi.
  end

  defp get_page_contents(page) do
    response = HTTPotion.get page
    response.body
  end

  @doc """
  map an anchor into a keyword list with the title and the url.
  """
  def anchors_to_keyword_list(anchor) do
    {_, [{"href", href}], [contents | _]} = anchor

    # Required to get the text inside HTML
    text = cond do
      is_tuple(contents) -> contents |> elem(2) |> hd
      true -> contents
    end

    [href: href, text: text]
  end
end
