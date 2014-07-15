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

class Review < ActiveRecord::Base
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
    todays_mails=UsersEmailControl.where("delivered_at > ?",@selected_date).where(:email_type_id=>[1,2,3]).count(:group=>'email_type_id')
    yesterdays_mails=UsersEmailControl.where(:delivered_at=>@yesterday_date..@selected_date).where(:email_type_id=>[1,2,3]).count(:group=>'email_type_id')
    #mails=UsersEmailControl.where("delivered_at > ?",@yesterday_date).select("email_type_id,delivered_at")
    #accounts=Account.where("created_at > ?",@yesterday_date)
    @todays_purchases = todays_mails[1]
    @todays_trr = todays_mails[2]
    @todays_mas = todays_mails[3]
    @todays_signups=Account.where("created_at > ?",@selected_date).count
    @todays_reviews=Review.where("created_at > ?",@selected_date).count

    @yesterdays_purchases = yesterdays_mails[1]
    @yesterdays_trr = yesterdays_mails[2]
    @yesterdays_mas = yesterdays_mails[3]
    @yesterdays_signups=Account.where(:created_at=>@yesterday_date..@selected_date).count
    @yesterdays_reviews=Review.where(:created_at=>@yesterday_date..@selected_date).count

    #@account_vero = TaskResourceStatus.where("started_at > ?",@selected_date).where(:task_name=>'users:accounts_events').count
    @user_vero = TaskResourceStatus.where("started_at > ?",@selected_date).where(:task_name=>'users:vero_events').count

    erb :index

  end

end

graph "Market Share", :type => 'pie' do
  pie "Share", { "Product one" => 100, "Product Two" => 300 }
end
