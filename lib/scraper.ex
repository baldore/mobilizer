defmodule Mobilizer.Scraper do
  def scrap do
    # Initial variables
    source_page = "http://elespejogotico.blogspot.com.co/2007/11/relatos-y-cuentos-de-lovecraft.html"

    IO.puts "Finding links..."

    titles = get_elements_from_url(".post-body li a", source_page)
      |> Enum.map(&anchors_to_keyword_list/1)

    IO.puts "Fetching contents from each url..."

    contents = titles
      |> Enum.take(1)
      |> Enum.map(&get_page_contents/1)

    contents

    # Next Steps
    # X Convert the links into a list of dictionaries.
    # - Run through each url and get the contents of each story.
    # - Create a new list of dictionaries with the stories and its titles.
    # - Create the book.
    # - Convert to mobi.
  end

  def get_page_contents(page_info) do
    href = Keyword.get(page_info, :href)

    IO.puts "Fething from: #{href}"

    content = get_elements_from_url(".post-body", href)
      |> Floki.text

    Keyword.put(page_info, :content, content)
  end

  def get_elements_from_url(selector, url) do
    request = HTTPotion.get(url)

    case request.status_code do
      302 -> get_elements_from_url(selector, request.headers.hdrs[:location])
      _   -> request |> Map.get(:body) |> Floki.find(selector)
    end
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
