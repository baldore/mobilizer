defmodule Mobilizer.Scraper do
  def scrap do
    # Initial variables
    page = "http://elespejogotico.blogspot.com.co/2007/11/relatos-y-cuentos-de-lovecraft.html"

    titles = get_titles_from_url page

    titles

    # Next Steps
    # X Convert the links into a list of dictionaries.
    # - Run through each url and get the contents of each story.
    # - Create a new list of dictionaries with the stories and its titles.
    # - Create the book.
    # - Convert to mobi.
  end

  def get_titles_from_url(url) do
    url
      |> HTTPotion.get
      |> Map.get(:body)
      |> Floki.find(".post-body li a")
      |> Enum.map(&anchors_to_keyword_list/1)
  end

  @doc """
  map an anchor into a keyword list with the title and the url.
  """
  def anchors_to_keyword_list(anchor) do
    {_, [{"href", href}], contents} = anchor
    title = Floki.text(contents)
    [href: href, title: title]
  end
end
