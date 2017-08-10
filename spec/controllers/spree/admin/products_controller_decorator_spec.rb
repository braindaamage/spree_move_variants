require 'spec_helper'

RSpec.describe Spree::Admin::ProductsController, type: :controller do
  let(:admin) 	 { FactoryGirl.create(:admin_user) }
  let(:product1)  { FactoryGirl.create(:product) }
  let(:product2)  { FactoryGirl.create(:product) }
  let(:variant)   { FactoryGirl.create(:variant) }

  before do
    sign_in(admin)
    product1.variants << [variant, FactoryGirl.create(:variant)]
    product2.variants << [FactoryGirl.create(:variant)]
  end

  context '#move_variant' do
    it 'return product and variant' do
      spree_get :move_variant, slug: product1.slug, sku: variant.sku
      expect(response).to be_success
      expect(response).to render_template('move_variant')
      expect(assigns(:product)).not_to be_nil
      expect(assigns(:variant)).not_to be_nil
    end
  end

  context '#find_product' do
    it 'find by name' do
      spree_post :find_product, format: 'js', name_destino: product2.name, sku: ''
      expect(response).to be_success
      expect(assigns(:product)).not_to be_nil
    end

    it 'find by sku' do
      spree_post :find_product, format: 'js', name_destino: '', sku_destino: product2.variants.first.sku
      expect(response).to be_success
      expect(assigns(:product)).not_to be_nil
    end

    it 'do not find product' do
      spree_post :find_product, format: 'js', name_destino: 'test', sku_destino: ''
      expect(response).to be_success
      expect(assigns(:product)).to be_nil
    end
  end
  
  context '#exchange_product' do
    it 'move variant betwen products' do
      spree_post :exchange_product, product_id: product2.id, sku: variant.sku
      product2.reload
      expect(product2.variants).to include(variant)
      expect(response).to redirect_to("/admin/products/#{product2.slug}/variants")
    end

    it 'redirect to original product variants list if product destination dont exist' do
      spree_post :exchange_product, product_id: 10000, slug: product1.slug
      expect(response).to redirect_to("/admin/products/#{product1.slug}/variants")
    end

    it 'delete product if variants empty' do
      expect {
        spree_post :exchange_product, product_id: product1.id, sku: product2.variants.first.sku, 
                                      slug: product2.slug, delete_old: 1
      }.to change{Spree::Product.count}.by(-1)
    end
  end
end
