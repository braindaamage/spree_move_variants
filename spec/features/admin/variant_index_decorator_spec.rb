require 'spec_helper'

describe "VarintIndex", :type => :feature do
  stub_authorization!
  let(:product)   { FactoryGirl.create(:product) }
  let(:variant)   { FactoryGirl.create(:variant) }

  before do
    product.variants << [variant]
  end

  context 'visiting admin product variants list' do
    it "should redirect to variant move view" do
      visit spree.admin_product_variants_path(product)
      first('a.fa-exchange').click
      expect(current_path).to eq("/admin/products/#{variant.slug}/variants/#{variant.sku}/move")
    end
  end
end