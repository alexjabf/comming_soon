class User < ActiveRecord::Base
  belongs_to :role

  #ASSOCIATIONS
  has_one :account
  has_many :apps, :through => :accounts, :dependent => :destroy
  has_many :app_add_ons, :through => :accounts, :dependent => :destroy
  has_many :custom_scaffolds, :through => :apps, :dependent => :destroy
  has_many :column_attributes, :through => :custom_scaffolds, :dependent => :destroy


  #NESTED ATTRIBUTES

  #VALIDATIONS
  validates :first_name, :last_name, :active, :role_id, :presence => true
  USER_FIRST_NAME = /^[a-zA-Z., ]+$/
  USER_LAST_NAME = /^[a-zA-Z., ]+$/
  USER_ACTIVE = /^t|^f/
  USER_ROLE_ID = /^[0-9]+$/
  validates :first_name, format: { with: USER_FIRST_NAME, multiline: true }, length: { within: 1..30 }
  validates :last_name, format: { with: USER_LAST_NAME, multiline: true }, length: { within: 1..30 }
  validates :active, format: { with: USER_ACTIVE, multiline: true }, length: { within: 1..5 }
  validates :role_id, format: { with: USER_ROLE_ID, multiline: true }, length: { within: 1..5 }


  #FUNCTIONS
  def select_display
    first_name.to_s + '  ' + last_name.to_s
  end
  def select_value
    first_name.to_s + '  ' + last_name.to_s
  end
  def select_autocomplete
    first_name.to_s + '  ' + last_name.to_s
  end
  def fullname
    first_name + '  ' + last_name.to_s
  end
  has_one :account, :dependent => :destroy
  acts_as_avatarable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable, :confirmable 
  attr_accessor :login, :fullname
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  end
  
  #protected

  # Attempt to find a user by it's email. If a record is found, send new
  # password instructions to it. If not user is found, returns a new user
  # with an email not found error.
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end 

  def self.find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
    (case_insensitive_keys || []).each { |k| attributes[k].try(:downcase!) }

    attributes = attributes.slice(*required_attributes)
    attributes.delete_if { |key, value| value.blank? }

    if attributes.size == required_attributes.size
      if attributes.has_key?(:login)
        login = attributes.delete(:login)
        record = find_record(login)
      else  
        record = where(attributes).first
      end  
    end  

    unless record
      record = new

      required_attributes.each do |key|
        value = attributes[key]
        record.send("#{key}=", value)
        record.errors.add(key, value.present? ? error : :blank)
      end  
    end  
    record
  end

  def self.find_record(login)
    where(["username = :value OR email = :value", { :value => login }]).first
  end 

end
