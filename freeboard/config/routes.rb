Freeboard::Engine.routes.draw do
  get ':key'              => 'dashboard#index'
  post '_save_board/:key' => 'dashboard#save_board'
  get  '_get_board/:key'  => 'dashboard#get_board'
end
