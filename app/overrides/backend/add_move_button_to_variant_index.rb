Deface::Override.new(:virtual_path => 'spree/admin/variants/index',
                    :name => 'add_move_button_to_variant_index',
                    :insert_bottom => "tbody td.actions",
                    :text => '
                        &nbsp;
                        <%= link_to("", admin_move_variant_path(variant.slug, variant.sku), { data: { action: "edit " }, class: "fa fa-exchange icon_link with-tip no-text" }) %>
                    ')
