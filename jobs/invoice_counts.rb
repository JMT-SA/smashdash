query = <<-EOQ
SELECT 'Inv awaiting approval' AS type, count(*)
FROM invoices
WHERE invoice_type = 'CUSTOMER' AND NOT approved AND NOT cancelled AND completed
UNION ALL
SELECT 'CN awaiting approval' AS type, count(*)
FROM invoices
WHERE invoice_type = 'CREDIT_NOTE' AND NOT approved AND NOT cancelled AND completed
UNION ALL
SELECT 'DN awaiting approval' AS type, count(*)
FROM invoices
WHERE invoice_type = 'DEBIT_NOTE' AND NOT approved AND NOT cancelled AND completed
EOQ

SCHEDULER.every '20s' do
  res = DBEX[query].all.map { |r| { label: r[:type], value: r[:count] } }
  send_event('invoices', { items: res })
end
