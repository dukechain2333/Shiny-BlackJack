hard_play <- function(hands) {

  # Calculate the total of each hand
  opponent_total <- sum(hands$opponent)
  player_total <- sum(hands$me_player)

  # Calculate the maximum total among all players
  max_total <- if (opponent_total > player_total) opponent_total else player_total

  # Calculate the average value of the remaining cards in the deck
  avg_remaining <- (364 - sum(opponent_total + player_total)) / (52 - (length(hands$opponent) + length(hands$me_player)))

  # Decide whether to hit or stand based on the conditions
  if (max_total > 21) {
    play <- 'S'
  } else if (opponent_total < max_total & max_total != 0) {
    play <- 'H'
  } else if (opponent_total < 19 - avg_remaining) {
    play <- 'H'
  } else {
    play <- 'S'
  }

  return(play)
}


