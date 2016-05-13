defmodule Mobilizer.Scraper do
  @doc """
  Main function. Gets all the contents from the blog and generates a
  .mobi file for kindle.
  """
  def scrap do
    # Options
    source_page = "http://elespejogotico.blogspot.com.co/2007/11/relatos-y-cuentos-de-lovecraft.html"
    generated_folder = "_book"

    IO.puts "Finding links..."

    titles = get_elements_from_url(".post-body li a", source_page)
      |> Enum.map(&anchors_to_keyword_list/1)

    IO.puts "Fetching contents from each url..."

    contents = titles
      |> Enum.take(1)
      |> Enum.map(&get_page_contents/1)


    File.rm_rf generated_folder # Clean the generated folder
    File.mkdir generated_folder

    generate_xml "#{generated_folder}/params.xml", [
      title: "Cuentos de H.P. Lovecraft",
      lang: "es",
      author: "H.P. Lovecraft",
      publisher: "elespejogotico.blogspot.com",
      date: get_date_now,
      rights: "Nothing here..."
    ]

    contents

    # Next Steps
    # X Convert the links into a list of dictionaries.
    # X Run through each url and get the contents of each story.
    # X Create a new list of dictionaries with the stories and its titles.
    # - Generate the xml that will define the parameters of the book.
    # - Create the book.
    # - Convert to mobi.
  end

  @doc """
  Returns the date today using the format YYYY/MM/DD
  """
  def get_date_now do
    {{year, raw_month, day}, _} = :os.timestamp |> :calendar.now_to_datetime
    month = raw_month |> to_string |> String.rjust(2, ?0)

    "#{day}/#{month}/#{year}"
  end

  @doc """
  Get the contents of a page and returns an extended map with the contents
  ad  ded.
  """
  def get_page_contents(page_info) do
    href = Keyword.get(page_info, :href)

    IO.puts "Fething from: #{href}"

    content = get_elements_from_url(".post-body", href)
      |> Floki.text

    Keyword.put(page_info, :content, content)
  end

  @doc """
  Find the selected elements inside the page located in the url.
  """
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

  def generate_xml(output_file, params) do

  end
end
