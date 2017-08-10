require 'spec_helper'

describe "VarintMove", :type => :feature, js: true do
  stub_authorization!
  let(:product1)   { FactoryGirl.create(:product) }
  let(:product2)   { FactoryGirl.create(:product) }
  let(:variant)   { FactoryGirl.create(:variant) }

  before do
    product1.variants << [variant, FactoryGirl.create(:variant)]
    product2.variants << [FactoryGirl.create(:variant)]
  end

  context 'move variants' do
    it 'visit move variants view' do
      visit spree.admin_move_variant_path(variant.slug, variant.sku)
      expect(page).to have_content('Buscar Producto')
      expect(page).to have_content(variant.sku)
    end

    it 'find product destination by name' do
      visit spree.admin_move_variant_path(variant.slug, variant.sku)
      fill_in 'name_destino', with: product2.name
      click_button 'Buscar'
      wait_for_ajax
      expect(page).to have_content(product2.name)
    end

    it 'find product destination by sku' do
      visit spree.admin_move_variant_path(variant.slug, variant.sku)
      fill_in 'sku_destino', with: product2.variants.first.sku
      click_button 'Buscar'
      wait_for_ajax
      expect(page).to have_content(product2.name)
    end

    it 'move variant betwen products' do
      visit spree.admin_move_variant_path(variant.slug, variant.sku)
      fill_in 'sku_destino', with: product2.variants.first.sku
      click_button 'Buscar'
      wait_for_ajax
      click_button 'Mover'
      expect(current_path).to eq("/admin/products/#{product2.slug}/variants")
      expect(page).to have_content(variant.sku)
    end
  end
end
