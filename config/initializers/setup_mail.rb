ActionMailer::Base.smtp_settings = {
  :address              => "email-smtp.us-east-1.amazonaws.com",
  :port                 => 587,
  :domain               => "nowon.com.br",
  :user_name            => "AKIAIBXCNZQPPG7L77EQ",
  :password             => "At28SDH+ZcDdRVVcs/owsEoRDDWNU5Y1twx2vnVQZxlP",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?