query = <<-EOQ
SELECT DISTINCT ON (probe_uid, unit_uid) probe_uid AS coldstore, unit_uid, CAST(value AS numeric(3,1)) AS temperature, created_at
FROM messcada_coldstorage_ra
ORDER BY probe_uid, unit_uid, created_at desc
EOQ

SCHEDULER.every '1m', :first_in => 0 do
  res = DB[query].all

  res.each do |rec|
    ln = rec[:coldstore]
    send_event("cs_#{ln}", { current: rec[:temperature], title: ln, moreinfo: rec[:unit_uid] })
    send_event("cs_gauge_#{ln}", { current: rec[:temperature].to_f, moreinfo: rec[:created_at].strftime('%Y-%m-%d %H:%M:%S') })
  end
end
