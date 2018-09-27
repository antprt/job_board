class CreateApplies < ActiveRecord::Migration[5.2]
  def change
    create_table :applies do |t|
      t.integer :status
      t.boolean :highlight, default: false
      t.references :user, foreign_key: true
      t.references :job_advert, foreign_key: true

      t.timestamps
    end
    add_index :applies, [:job_advert_id, :user_id], unique: true, :name => 'job_advert_user'
  end
end
