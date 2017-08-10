Spree::Admin::ProductsController.class_eval do
  def move_variant
    @product = Spree::Product.find_by(slug: params[:slug])
    @variant = Spree::Variant.find_by_sku(params[:sku])
  end

  def find_product
    name = params[:name_destino]
    sku = params[:sku_destino]
    @product = nil
    if name.empty?
      if !(variant = Spree::Variant.find_by_sku(sku)).nil?
        @product = variant.product
      end
    else
      search = Spree::Product.ransack({ name_cont: name })
      @product = search.result.first
    end

    respond_to do |format|
      format.js   {}
      format.html { redirect_to request.referer }
    end
  end

  def exchange_product
    delete_old = params[:delete_old] || false
    product = Spree::Product.find(params[:product_id]) rescue nil
    if !product.nil?
      variant = Spree::Variant.find_by_sku(params[:sku])
      variant.update product_id: product.id
      if delete_old
        product_old = Spree::Product.find_by(slug: params[:slug])
        product_old.destroy! if product_old.variants.empty?
      end
      redirect_to admin_product_variants_path(product)
    else
      redirect_to admin_product_variants_path(params[:slug])
    end
  end
end
