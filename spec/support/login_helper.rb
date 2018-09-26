module LoginHelper   
  def login(user)
    post "/login", params: { user: { email: user.email, password: user.password } } 
    return response.headers["Authorization"]
  end
end