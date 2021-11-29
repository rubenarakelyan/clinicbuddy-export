require 'cgi'
require 'faraday'
require 'nokogiri'
require 'tty-prompt'

BASE_URL = "https://ww1.clinicbuddy.com/".freeze

# Get a session cookie for authentication
prompt = TTY::Prompt.new
session_cookie = prompt.ask("Session cookie:")

Dir.glob("invoices/*.html").each do |file|
  # Make a new directory for each patient
  patient_id = File.basename(file, ".html")
  puts "Making directory for patient #{patient_id}..."
  Dir.mkdir("invoices/#{patient_id}")

  # Extract and download invoices for each patient
  doc = Nokogiri::HTML(File.read(file))
  invoices = doc.css('a[target="_blank"]').each do |invoice|
    url = "#{BASE_URL}#{invoice.attr('href')}"
    invoice_id = CGI.parse(URI.parse(url).query)["invoice_id"][0]
    puts "Downloading invoice #{invoice_id} for patient #{patient_id}..."
    output = Faraday.get(url, nil, "Cookie" => session_cookie)
    File.write("invoices/#{patient_id}/#{invoice_id}.pdf", output.body)
  end
end
