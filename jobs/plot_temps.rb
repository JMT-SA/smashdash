points = []
(1..10).each do |i|
  points << { x: i, y: rand(15) }
end
last_x = points.last[:x]

SCHEDULER.every '60m', first_in: 0 do

  points.shift
  last_x += 1
  points << { x: last_x, y: rand(15) }

  send_event('cs_plot_1', points: points)
end
