class CreateCompanyUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :company_users do |t|      
			t.references :company, foreign_key: true, null: false      
			t.references :user,    foreign_key: true, null: false      
			t.timestamps    
		end    
     add_index :company_users, [:company_id, :user_id], unique: true  
  end
end
