defmodule Mobilizer.Scraper do
  def scrap do
    # Initial variables
    page = "http://guialiteraria.blogspot.com.co/2013/08/cuentos-hp-lovecraft-online.html"
    selector = ".entry-content li a"

    body = getPageContents(page)

    links = Floki.find(body, selector);

    # Pattern matching for each link
    # {_, [{"href", url}], [title]}

    # Next Steps
    # - Convert the links into a list of dictionaries.
    # - Run through each url and get the contents of each story.
    # - Create a new list of dictionaries with the stories and its titles.
    # - Create the book.
    # - Convert to mobi.
  end

  defp getPageContents(page) do
    response = HTTPotion.get page
    response.body
  end
end
