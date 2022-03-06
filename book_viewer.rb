require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |line, index|
      "<p id=paragraph#{index}>#{line}</p>"
    end.join
  end
end
    

get "/" do
  @title = "Elementary, Dear Watson"
  @current_time = Time.now
  erb :home
  # '<h1>The End</h1><p>This is the end.</p><p>This may come as a surprise.<p>'
  # File.read "public/template.html"
end

get "/chapters/:number" do
  @title = @contents[params[:number].to_i - 1]
  @chapter = in_paragraphs(File.read("data/chp#{params[:number]}.txt"))
  erb :chapter
end

get "/search" do
  @results = []
  if params[:query]
    1.upto(12) do |i|
      @results << i if File.read("data/chp#{i}.txt").include?(params[:query])
    end
  end
  erb :search
end

not_found do
  redirect "/"
end
