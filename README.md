# ClinicBuddy Export

Two scripts to export patient invoices from ClinicBuddy for import into other systems.

ClinicBuddy does not have an API, so these scripts perform screen scraping and manual file downloads.

## Running the scripts

Each script can be run with `ruby script.rb`.

The session cookie can be found by opening the developer tools in your browser, visiting the network tab and cicking any link in ClinicBuddy. Then choose one of the resulting network activity items in developer tools, and scroll down to the request headers. One of the cookies will start with `PHPSESSID` - copy this entire string from `PHPSESSID` to the first `;` and use it as the session cookie.

The first and last patient ID can be found in ClinicBuddy by generating a table of all patients (gear wheel > Apps > Economy Management > Management > Patient Management > Show).

### export-invoice-lists.rb

This script iterates through all patients and downloads an HTML file for each which contains links to all their invoices, storing them in `invoices`.

### export-invoices.rb

This script iterates through all of the HTML files downloaded by the previous script, scrapes them for links to invoices, and downloads the invoices as PDFs, storing them in per-patient folders (based on the patient ID) inside `invoices`.
