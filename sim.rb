require File.expand_path("calc.rb",File.dirname(__FILE__))


output = ""
round = 0
stack = 500

diffs = []

while stack > 0
  #sleep 0.25

  puts '###############################'

  initial_stack = stack
  puts "Initial stack == #{initial_stack}"

  ante = stack.to_f / 10
  stack -= ante
  puts "Ante == #{ante}"
  puts "Stack after ante == #{stack}"
  
  pot = Random.rand(50..500)
  puts "Round #{round}"
  round += 1
  puts "Pot == #{pot}"

  call = Random.rand(0...40)
  puts "Call this hand == #{call}"

  hand = Random.rand(1...7462)
  puts "Hand value == #{hand}"

  prob = Calc.hand_prob(hand)
  puts "Probabilty of winning with hand == #{prob}"

  kelly = Calc.kelly(prob)
  puts "Kelly == #{kelly}"

  ev_call = Calc.ev_call(prob, pot, call)
  puts "EV if call == #{ev_call}"

  if (ev_call < 0)
    puts "GOING TO FOLD"
    puts "LOST #{initial_stack - stack}"
    next
  end

  puts "GOING TO CALL"
  stack -= call


  win = Random.rand(1...7462)
  puts "Win hand calc == #{win}"
  
  if hand < win
    stack += pot
    puts "WON #{stack - initial_stack}"
  else
    puts "LOST #{initial_stack - stack}"
  end
  if stack > 500
    puts "UP #{stack - 500}"
  else
    puts "DOWN #{500 - stack}"
  end
  puts output
  diffs << stack
end

File.open('output.txt', 'w') {|f| f.write(diffs.join("\n")) }