require 'open-uri'
require 'json'
require 'net/http'

%w(calc replace).each do |file|
  require File.expand_path("#{file}.rb",File.dirname(__FILE__))
end

BASE    = 'http://ec2-54-235-169-130.compute-1.amazonaws.com/'
SANDBOX = 'sandbox/players/'
LIVE    = 'api/players/'

ACTION = "/action"

PLAYER_KEY = ""

SANDBOX_INITIAL_DEAL_KEY = 'initial-deal-key'
SANDBOX_REPLACEMENT_KEY  = 'replacement-stage-key'
FINAL_BET_KEY            = 'final-bet-key'

LOG = open('log.txt', 'a')

def poker(key, num_run = nil, sandbox = false)
  if num_run
    (1..num_run).each { |n| logic(key, sandbox) }
  else
    logic(key, sandbox) while true
  end
end

def logic(key, sandbox = false)
  # Your client should sleep 1 second.
  # If you send too many requests at once, we will start throttling your requests.
  # This will cause you to reach the timeout limit which will cause your player to FOLD.
  sleep 1
  #puts "Checking state"
  time = Time.now  

  # GET request.
  # Ask the server "What is going on?"
  turn_data = game_state(key, sandbox)
  
  # Logic!!
  # This logic is boring. But, yours should be more epic!
  if turn_data["your_turn"]
    log '#######################################'
    log "It is our turn, round number #{turn_data['round_id']}"
    log "It is #{turn_data['betting_phase']}"
    log "Current stack is #{turn_data['stack']}"
    
    if turn_data["betting_phase"] ==  "deal" || turn_data["betting_phase"] ==  "post_draw"
      log "We have the hand #{turn_data['hand'].join(' ')}"
      hand = turn_data["hand"]
      value = hand_value(hand)
      log "The value of the hand is #{value}"
      prob = Calc.hand_prob(value)
      rank1 = Calc.get_hand_rank(value)
      log "The rank of the hand is #{rank1}"
      log "The prob of winning is #{prob}"
      stack = turn_data["stack"]
      pot = 0
      turn_data["players_at_table"].each do |player|
        pot += player["current_bet"]
      end
      log "The pot is #{pot}"
      call = turn_data["call_amount"]
      ev_call = Calc.ev_call(prob, pot, call)
      log "The EV is #{ev_call}"

      kelly = Calc.kelly(prob)
      ev_raise = Calc.ev_raise(prob, pot, call, kelly, stack)
      log "Kelly is #{kelly} and ev_raise is #{ev_raise}, kstack is #{kelly * stack}"
      # r = (kelly * stack) * 0.3
      # if ev_raise > ev_call - 15 && ev_raise > -20
      #   params = {
      #     :action_name => "raise",
      #     :amount => r.round
      #   }
      #   log "Going to raise with ev #{ev_raise} and raise #{r.round}"
      #   player_action(key, params, sandbox)
      if prob >= 0.5
        params = {
          :action_name => "raise",
          :amount => (kelly * stack * 0.5).round
        }
        log "Going to raise with ev #{ev_raise} and raise #{(kelly * stack * 0.5).round}"
        player_action(key, params, sandbox)
      elsif ev_call > 0 && stack >= call && call <= stack.to_f * 0.6
        params = {
          :action_name => "call"
        }
        log "Going to call with ev #{ev_call} and current_call #{turn_data['call_amount']}"
        player_action(key, params, sandbox)
      else
        #do fold
        params = {
          :action_name => "fold"
        }
        log "Going to fold"
        player_action(key, params, sandbox)
      end
    elsif turn_data["betting_phase"] == "draw"
      value = hand_value(turn_data["hand"])
      rank = Calc.get_hand_rank(value)
      replace = Replace.replace(rank, turn_data["hand"])
      params = {
        :action_name => "replace",
        :cards => replace.join(' ')
      }
      log "Replacing cards #{replace.join(' ')}"
      player_action(key, params, sandbox)
    end
    
  end
  puts "Time took #{Time.now - time}"
end

def log(str)
  puts str
  LOG.puts str
end

# GET
def game_state(key, sandbox = false)
  # do a get request to http://no-limit-code-em.com/api/players/:key
  if sandbox
    url = BASE + SANDBOX + key
  else
    url = BASE + LIVE + key
  end
  result = JSON.parse(open(url).read)
end

# POST
def player_action(key, params, sandbox = false)
  # do a post request to http://no-limit-code-em.com/api/players/:key/action
  t = Time.now
  if sandbox
    uri = URI.parse(BASE + SANDBOX + key + ACTION)
  else
    uri = URI.parse(BASE + LIVE + key + ACTION)
  end
  puts uri

  response = Net::HTTP.post_form(uri, params)
  log "Time to post action is #{Time.now - t}s"
end

def hand_value(hand)
  `eval/allfive #{hand.join(' ')}`.to_i
end

poker(PLAYER_KEY)