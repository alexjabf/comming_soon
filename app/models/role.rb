class Role < ActiveRecord::Base  
  #ASSOCIATIONS
  has_many :apps, :through => :users, :dependent => :destroy
  has_many :app_add_ons, :through => :users, :dependent => :destroy
  has_many :accounts, :through => :users, :dependent => :destroy
  has_one :user, :dependent => :destroy
  has_many :permissions, :dependent => :destroy
  
  #NESTED ATTRIBUTES
  
  #VALIDATIONS
  validates :description, :name, :presence => true
  validates :name, :description, :uniqueness => true
  validates_length_of :name, :maximum => 150
  validates_length_of :description, :maximum => 3000
  
  self.per_page = 20
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |model|
        csv << model.attributes.values_at(*column_names)
      end
    end
  end
  
  
  #FUNCTIONS
  def select_display
    name
  end
  
  def select_value
    name
  end
  
  def select_autocomplete
    name
  end
  
end
