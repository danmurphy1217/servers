Rails.application.routes.draw do

  # get '/' => 'welcome#hello', :as => '/' # WelcomeController#/ <- can do this
  get 'welcome/hello' # <- or these three lines
  resources :articles
  root 'welcome#hello'


  get '/hello' => 'welcome#index', :as => 'hello' # WelcomeController#hello
  get '/hello-two' => 'welcome#hello2', :as => 'hello_two' # WelcomeController#hello_two
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
