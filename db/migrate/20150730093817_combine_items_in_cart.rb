class CombineItemsInCart < ActiveRecord::Migration
  
  def up
    #remplacez les exemplaires d'un produit  singulier dans le panier avec un unique article
    Cart.all.each do |cart|
      #Comptez le nombre de chaque produit dans le panier
      sums = cart.line_items.group(:product_id).sum(:quantity)
      sums.each do |product_id, quantity|
        if quantity>1
          #Eliminez les articles singuliers
          cart.line_items.where(product_id: product_id).delete_all
          #Remplacez avec un unique article
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end 
    end
  end
  
  #def down
    #Subdivisez les articles avec une quantité superieur à 1 en plus ligne dans la table LineItem
    #LineItem.where("quantity>1").each do |line_item|
      #Ajoutez les articles donc la quantité = 1
      #line_item.quantity.times do
        #LineItem.create cart_id: line_item.cart_id, product_id: line_item.product_id, quantity: 1
      #end
      #Supprimer l'article originale
       #line_item.destroy
   # end
  #end
end
