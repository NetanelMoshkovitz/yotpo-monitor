require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/graph'
require 'active_record'
require 'yaml'

# ActiveRecord::Base.establish_connection(
#     :adapter  => "mysql2",
#     :host     => "localhost",
#     :username => "root",
#     :password => "vladopen",
#     :database => "yotpoapistaging"
# )
DB_CONFIG = YAML::load(File.open('config/database.yml'))

set :database_file, "config/database.yml"

class Account < ActiveRecord::Base
end

class TaskResourceStatus < ActiveRecord::Base
end

class UsersEmailControl < ActiveRecord::Base
end

class App < Sinatra::Application
  get '/' do
    #"#{User.last.email}"
    @selected_date=Date.current
    @yesterday_date=@selected_date-1.day
    mails=UsersEmailControl.where("delivered_at > ?",@yesterday_date).select("email_type_id,delivered_at")
    accounts=Account.where("created_at > ?",@yesterday_date)
    @todays_purchases = mails.where(:email_type_id=>1).where("delivered_at > ?",@selected_date).count
    @todays_trr = mails.where(:email_type_id=>2).where("delivered_at > ?",@selected_date).count
    @todays_mas = mails.where(:email_type_id=>3).where("delivered_at > ?",@selected_date).count
    @todays_signups=accounts.where("created_at > ?",@selected_date).count

    @yesterdays_purchases = mails.where(:delivered_at=>@yesterday_date..@selected_date,:email_type_id=>1).count
    @yesterdays_trr = mails.where(:delivered_at=>@yesterday_date..@selected_date,:email_type_id=>2).count
    @yesterdays_mas = mails.where(:delivered_at=>@yesterday_date..@selected_date,:email_type_id=>3).count
    @yesterdays_signups=accounts.where(:created_at=>@yesterday_date..@selected_date).count

    #@account_vero = TaskResourceStatus.where("started_at > ?",@selected_date).where(:task_name=>'users:accounts_events').count
    @user_vero = TaskResourceStatus.where("started_at > ?",@selected_date).where(:task_name=>'users:user_events').count

    erb :index

  end

end

graph "Market Share", :type => 'pie' do
  pie "Share", { "Product one" => 100, "Product Two" => 300 }
end
