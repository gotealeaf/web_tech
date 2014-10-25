class Surfing
  def call(env)
    request = Rack::Request.new(env)
    path = request.path
    if File.exists?("documents#{path}")
      content = File.read("documents#{path}")
      [200, {"Date" => Time.now.ctime}, [content]]
    else
      [404, {}, ["Can't locate the document"]]
    end
  end
end
