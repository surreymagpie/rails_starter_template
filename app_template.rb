# This template will step through  commonly repeated
# steps in the generation of any new rails project
#
# run 'rails new app -T -B -m path/to/this/app_template.rb'
#
# Consider using --skip-keeps, and choosing development
# database e.g. -d postgresql

# ==========================================================
# Set up a Markdown flavoured README ready for Github
# ==========================================================

run 'rm README.rdoc && touch README.md'
append_file 'README.md', "# #{app_name.humanize}\n\nTODO..."

# ==========================================================
# Set up commonly used gems
# ==========================================================

gem 'haml-rails'
gem 'puma'
gem 'faker'

gem_group :production do
  gem 'rails_12factor'
end

gem_group :development do
  gem 'annotate'
  gem 'awesome_print', require: 'ap'
  gem 'better_errors'
  gem 'quiet_assets'
end

gem_group :development, :test do
  gem 'guard-rspec', require: false
  gem 'rb-inotify', require: false
  gem 'rspec-rails', require: false
end

gem_group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'spring-commands-rspec'
end

run 'bundle install'
git :init
git add: '.'
git commit: "-m 'Initial commit'"

# ==========================================================
# Convert the app layout to HAML and set up stylesheet
# ==========================================================

generate 'haml:application_layout', 'convert'
run 'git rm app/views/layouts/application.html.erb'
run 'git rm app/assets/stylesheets/application.css'
create_file 'app/assets/stylesheets/application.css.scss'

git add: '.'
git commit: "-m 'Convert the app layout to HAML and set up stylesheet'"

# ==========================================================
# Set up test framework
# ==========================================================

run 'spring binstub --all'
run 'spring stop'
generate "rspec:install"
append_file ".rspec", "--format documentation\n"
run 'bundle exec guard init rspec'
gsub_file("Guardfile", 'cmd: "bundle exec rspec"', 'cmd: "bundle exec spring rspec", all_on_start: true')

git add: '.'
git commit: "-m 'Setup spring, guard and rspec'"

# ==========================================================
# Configuration of rspec
# ==========================================================

# Load capybara into test suite
insert_into_file 'spec/rails_helper.rb', after: "Rails is not loaded until this point!\n" do <<-CONFIG
require 'capybara/rails'
require 'capybara/rspec'
CONFIG
end

# Allow use of factories without keep typing 'FactoryGirl'
insert_into_file 'spec/rails_helper.rb', after: "RSpec.configure do |config|\n" do <<-CONFIG
  config.include FactoryGirl::Syntax::Methods
CONFIG
end

# Clean database on each test run
file "spec/support/database_cleaner.rb", <<-CODE
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
CODE
