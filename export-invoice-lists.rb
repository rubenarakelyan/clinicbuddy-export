require 'faraday'
require 'tty-prompt'

LIST_URL = "https://ww1.clinicbuddy.com/cb2.php?act=view_patient_provider".freeze

# Get details of which patients to export invoice lists for
# Also get a session cookie for authentication
prompt = TTY::Prompt.new
patient_first_id = prompt.ask("Patient first ID:", convert: :integer)
patient_last_id = prompt.ask("Patient last ID:", convert: :integer)
session_cookie = prompt.ask("Session cookie:")

# Get the list of invoices for each patient as an HTML file (to be parsed later)
(patient_first_id..patient_last_id).each do |id|
  puts "Getting invoice list for patient #{id}..."
  output = Faraday.post(LIST_URL, "act=psi&id=#{id}", "Cookie" => session_cookie)
  File.write("invoices/#{id}.html", output.body)
end
