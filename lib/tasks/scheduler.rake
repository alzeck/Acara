task :send_weekly_report => :environment do
  User.send_report_email_all
end
