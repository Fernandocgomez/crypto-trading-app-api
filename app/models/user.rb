class User < ApplicationRecord

    # DB relationships
    has_secure_password
    has_one :portafolio

    # Global validations
    validates :username, :email, :password, :password_confirmation, :first_name, :last_name, presence: true
    validates :email, :username, uniqueness: true

    # First_name & Last_name
    validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/,
        message: "only allows letters" }
    

    # username validation
    validates :username, format: { with: /\A[a-zA-Z0-9]+\z/,
        message: "only allows letters and numbers" }
        validates :username, length: { minimum: 8 }
        validates :username, length: { maximum: 15 }

    # email validation
    validates :email, presence: true, 'valid_email_2/email': true
    validates :email, 'valid_email_2/email': { mx: true }
    validates :email, 'valid_email_2/email': { disposable: true }
    validates :email, 'valid_email_2/email': { disposable_domain: true }
    validates :email, 'valid_email_2/email': { disallow_subaddressing: true }
    validates :email, 'valid_email_2/email': { message: "is not a valid email" }
    validates :email, confirmation: true
    validates :email_confirmation, presence: true

    # password validation 
    def password_requirements_are_met
        rules = {
          " must contain at least one lowercase letter"  => /[a-z]+/,
          " must contain at least one uppercase letter"  => /[A-Z]+/,
          " must contain at least one digit (0-9)" => /\d+/,
          " must contain at least one special character (!,@,#,$,%,^,&,*,+,-,=)" => /[^A-Za-z0-9]+/
        }
        rules.each do |message, regex|
            errors.add( :password, message ) unless password.match( regex )
        end
    end

    validate :password_requirements_are_met
    validates :password, format: { without: /\s/, message: "No spaces allowed" }
    validates :password, length: { minimum: 8 }
    validates :password, length: { maximum: 20 }

end
