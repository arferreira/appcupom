class Faq < ActiveRecord::Base
  attr_accessible :type, :answer, :question
  self.inheritance_column = :faqs_type
end
