hard_play <- function(hands, my_ind) {
  # Calculate the total of each hand
  hand_totals <- sapply(hands, sum)

  # Calculate my total
  my_total <- hand_totals[my_ind]

  # Calculate the maximum total among all players
  max_total <- max(hand_totals)

  # Calculate the average value of the remaining cards in the deck
  avg_remaining <- (364 - sum(hand_totals)) / (52 - length(unlist(hands)))

  # Decide whether to hit or stand based on the conditions
  if (max_total > 21) {
    play <- 'S'
  } else if (my_total < max_total & max_total != 0) {
    play <- 'H'
  } else if (my_total < 19 - avg_remaining) {
    play <- 'H'
  } else {
    play <- 'S'
  }

  return(play)
}


