module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)["data"]
  end
end