class QuotesController < Rulers::Controller
  def index
    quotes = FileModel.all
    render :index, quotes: quotes
  end

  def a_quote
    render :a_quote, noun: :winking
  end

  def show
    quote = FileModel.find(params["id"])
    render :quote, obj: quote, ua: ua
  end

  def quote_1
    quote_1 = FileModel.find(1)
    render :quote, obj: quote_1, ua: ua
  end

  def new_quote
    attrs = {
      "submitter" => "web user",
      "quote" => "A picture is worth one k pixels",
      "attribution" => "Me"
    }
    m = FileModel.create attrs
    render :quote, :obj => m, ua: ua
  end

  def update_quote
    return "Page not found" if env["REQUEST_METHOD"] != "POST"

    quote_1 = FileModel.find(1)
    quote_1["submitter"] = "Updated Jeff"

    quote_1.save
    quote_1.inspect
  end

  def exception
    raise "It's a bad one!"
  end

  def view_test
    @noun = "roller skating"
    render :view_test
  end

  private

  def ua
    ua = request.user_agent
  end
end
