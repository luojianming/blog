class MyValidator < ActiveModel::Validator
  def validate(record)
    unless record.name.starts_with? 'X'
      record.errors[:name] << 'Need a name starting with X please!'
    end
  end
end
class Post < ActiveRecord::Base
  attr_accessible :content, :name, :title
  include ActiveModel::Validations
  validates_with MyValidator
  validate :title_cannot_have_digits
  def title_cannot_have_digits
    if (/\d/ =~ title)
      errors.add(:ljm,"title cannot have digits")
    end
  end
=begin  
  validates :name, :exclusion => { :in => %w(ljm),
                                   :message => "the username is reserved."}
  validates :name, :uniqueness => true
  validates :title, :format => { :with => /\A[a-zA-Z]+\z/,
                                 :message => "Only letters allowed"},
                                 :if => :is_me?
  def is_me?
    name == "luojm00"
  end
=end
  has_many :comments,:dependent => :destroy
  has_many :tags
  accepts_nested_attributes_for :tags, :allow_destroy => :true,
    :reject_if => proc {|attrs| attrs.all? {|k,v| v.blank?}}
end

