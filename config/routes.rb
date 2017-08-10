Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  namespace :admin do
    get 'products/:slug/variants/:sku/move', to: 'products#move_variant', as: :move_variant
    post 'products/:slug/variants/:sku/find', to: 'products#find_product', as: :move_variant_find
    post 'products/:slug/variants/:sku/exchange', to: 'products#exchange_product', as: :move_variant_exchange
  end
end
