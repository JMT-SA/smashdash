query = <<-EOQ
select qc_inspections.status, COUNT(qc_inspections.id) AS no_bins
from bins 
left join deliveries on deliveries.id = bins.delivery_id 
inner join farms on farms.id = bins.farm_id 
inner join rmt_products on rmt_products.id = bins.rmt_product_id 
JOIN qc_inspections on qc_inspections.business_object_id = bins.id 
JOIN qc_inspection_types on qc_inspection_types.id = qc_inspections.qc_inspection_type_id 
WHERE(qc_inspection_types.qc_inspection_type_code = 'PRETIP')
GROUP BY qc_inspections.status
EOQ

# SCHEDULER.every '15s' do
#   res = DB[query].all.map { |r| { label: r[:status], value: r[:no_bins] } }
#   send_event('pretip_bins', { items: res })
# end
