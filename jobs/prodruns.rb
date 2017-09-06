query = <<-EOQ
SELECT DISTINCT production_runs.line_code,
 production_runs.production_run_code, farm_puc_accounts.puc_code, 
lines.line_phc, production_runs.farm_code
FROM carton_label_setups
INNER JOIN active_carton_links ON (carton_label_setups.id = active_carton_links.carton_label_setup_id) 
INNER JOIN production_runs ON (active_carton_links.production_run_id = production_runs.id) 
INNER JOIN farm_puc_accounts ON (production_runs.farm_code = farm_puc_accounts.farm_code) AND (farm_puc_accounts.party_name = carton_label_setups.organization_code) 
INNER JOIN lines ON (production_runs.line_code = lines.line_code)
INNER JOIN farms ON (farm_puc_accounts.farm_id = farms.id) AND (farm_puc_accounts.farm_code = farms.farm_code) 
INNER JOIN pucs ON (farm_puc_accounts.puc_code = pucs.puc_code) 
INNER JOIN carton_setups ON (active_carton_links.carton_setup_id = carton_setups.id) 
INNER JOIN rmt_setups ON (carton_setups.production_schedule_id = rmt_setups.production_schedule_id) 
INNER JOIN carton_templates ON (carton_setups.id = carton_templates.carton_setup_id) 
WHERE farm_puc_accounts.role_name = 'MARKETER' -- AND production_runs.line_code = '49'
ORDER BY production_runs.line_code
EOQ

# SCHEDULER.every '15m', :first_in => 0 do
#   res = DB[query].all # .map { |r| { label: r[:status], value: r[:no_bins] } }
#   lkp = {}
#   headers = {production_run_code: 'Run',
#              line_phc: 'PHC',
#              farm_code: 'Farm',
#              puc_code: 'PUC'}
#   res.each do |rec|
#     lc = rec[:line_code]
#     lkp[lc] ||= []
#     %w{production_run_code line_phc farm_code puc_code}.each do |key|
#       sym = key.to_sym
#       hs = { label: headers[sym], value: rec[sym] }
#       lkp[lc] << hs unless lkp[lc].include?(hs)
#     end
#   end
#
#   ['1', '2', '3', '41', '42'].each do |ln|
#     send_event("line_#{ln}", { title: "LINE #{ln}", items: lkp[ln] })
#   end
#   # send_event('line_1', { items: lkp['1'] })
#   # send_event('line_41', { items: lkp['41'] })
# end
