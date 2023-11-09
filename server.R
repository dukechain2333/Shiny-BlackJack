#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("strategies.R")

# Define server logic required to play Black Jack
function(input, output, session) {

  # Initialize scores
  playerScore <- 0
  opponentScore <- 0
  playerWinTimes <- 0
  playerLoseTimes <- 0
  playerDrawTimes <- 0
  playerStatus <- "Playing"
  hitFlags <- reactiveValues(playerHitFlag = TRUE, opponentHitFlag = TRUE)
  playingFlags <- reactiveValues(playerPlayingFlag = TRUE, opponentPlayingFlag = FALSE)


  check_bust_winner <- function() {
    if (playerScore > 21 && opponentScore <= 21) {
      playerStatus <<- "Bust"
      output$playerStatus <- renderText({
        playerStatus
      })
      playerLoseTimes <<- playerLoseTimes + 1
      output$playerLoseTimes <- renderText({
        playerLoseTimes
      })
    }
    if (playerScore <= 21 && opponentScore > 21) {
      playerStatus <<- "Win"
      output$playerStatus <- renderText({
        playerStatus
      })
      playerWinTimes <<- playerWinTimes + 1
      output$playerWinTimes <- renderText({
        playerWinTimes
      })
    }
    if (playerScore > 21 && opponentScore > 21) {
      playerStatus <<- "Draw"
      output$playerStatus <- renderText({
        playerStatus
      })
      playerDrawTimes <<- playerDrawTimes + 1
      output$playerDrawTimes <- renderText({
        playerDrawTimes
      })
    }
    # else {
    #   # if (!hitFlags$playerHitFlag & !hitFlags$opponentHitFlag) {
    #   # }
    # }
  }

  first_time_deal <- function() {
    hands <<- list(me_player = deck[1:2], opponent = deck[3:4])
    deck <<- deck[-c(1:4)]
    playerScore <<- sum(hands$me_player)
    opponentScore <<- sum(hands$opponent)

    insertUI(
      selector = "#yourHand",
      ui = lapply(hands$me_player, function(card) {
        tags$div(
          style = "margin: 1vh; border-color: black; border-style: solid; display: flex; justify-content: center; align-items: center; height: 10vh; width: 5vh;",
          id = paste0("me_player", card),
          class = "card",
          tags$p(card)
        )
      })
    )
    insertUI(
      selector = "#opponentHand",
      ui = lapply(hands$opponent, function(card) {
        tags$div(
          style = "margin: 1vh; border-color: black; border-style: solid; display: flex; justify-content: center; align-items: center; height: 10vh; width: 5vh;",
          id = paste0("opponent", card),
          class = "card",
          tags$p(card)
        )
      })
    )

    # Check if player bust at the beginning
    check_bust_winner()
  }

  reset_game <- function() {
    # Remove all cards from UI
    removeUI(selector = ".card", multiple = TRUE)

    hitFlags$playerHitFlag <<- TRUE
    hitFlags$opponentHitFlag <<- TRUE
    playerStatus <<- "Playing"
    playingFlags$playerPlayingFlag <<- TRUE
    playingFlags$opponentPlayingFlag <<- FALSE
    deck <<- sample(rep(1:13, 4), replace = FALSE)
    first_time_deal()

    output$playerScore <- renderText({
      playerScore
    })
    output$opponentScore <- renderText({
      opponentScore
    })
    output$playerWinTimes <- renderText({
      playerWinTimes
    })
    output$playerLoseTimes <- renderText({
      playerLoseTimes
    })
    output$playerDrawTimes <- renderText({
      playerDrawTimes
    })
    output$playerStatus <- renderText({
      playerStatus
    })
  }

  observeEvent(input$restart, {
    session$reload()
  })

  observeEvent(input$nextRound, {
    reset_game()
  })

  observeEvent(input$hit, {
    if (hitFlags$playerHitFlag) {
      # Deal a card to player
      hands$me_player <<- c(hands$me_player, deck[1])
      deck <<- deck[-1]
      insertUI(
        selector = "#yourHand",
        ui = tags$div(
          style = "margin: 1vh; border-color: black; border-style: solid; display: flex; justify-content: center; align-items: center; height: 10vh; width: 5vh;",
          class = "card",
          tags$p(hands$me_player[length(hands$me_player)])
        )
      )
      # Update player score
      playerScore <<- sum(hands$me_player)
      output$playerScore <- renderText({
        playerScore
      })
      # Check if player busts
      if (playerScore > 21) {
        check_bust_winner()
        hitFlags$playerHitFlag <<- FALSE
        hitFlags$opponentHitFlag <<- FALSE
      }
      playingFlags$playerPlayingFlag <- FALSE
      playingFlags$opponentPlayingFlag <- TRUE
    }
    else {
      showNotification(
        "You cannot hit now!",
        type = "error"
      )
    }
  })

  observeEvent(input$stand, {
    hitFlags$playerHitFlag <<- FALSE
    playingFlags$playerPlayingFlag <<- FALSE
    playingFlags$opponentPlayingFlag <<- TRUE
  })

  # Opponent Behavior
  observe({
    while (playingFlags$opponentPlayingFlag == TRUE) {
      decision <- hard_play(hands)
      if (decision == "S") {
        hitFlags$opponentHitFlag <<- FALSE
        playingFlags$opponentPlayingFlag <<- FALSE
        showNotification(
          "Your Opponent choose to stand.",
          type = "message"
        )
      }
      else {
        showNotification(
          "Your Opponent choose to hit.",
          type = "message"
        )
        hands$opponent <<- c(hands$opponent, deck[1])
        deck <<- deck[-1]
        insertUI(
          selector = "#opponentHand",
          ui = tags$div(
            style = "margin: 1vh; border-color: black; border-style: solid; display: flex; justify-content: center; align-items: center; height: 10vh; width: 5vh;",
            class = "card",
            tags$p(hands$opponent[length(hands$opponent)])
          )
        )
        opponentScore <<- sum(hands$opponent)
        output$opponentScore <- renderText({
          opponentScore
        })
        # Check if opponent busts
        if (opponentScore > 21) {
          check_bust_winner()
          hitFlags$playerHitFlag <<- FALSE
          hitFlags$opponentHitFlag <<- FALSE
        }
        if (hitFlags$playerHitFlag == TRUE) {
          playingFlags$playerPlayingFlag <<- TRUE
          playingFlags$opponentPlayingFlag <<- FALSE
        }
      }
    }
  })

  # Check normal winner
  observe({
    if (hitFlags$playerHitFlag == FALSE & hitFlags$opponentHitFlag == FALSE) {
      if (playerScore > opponentScore && playerScore <= 21) {
        playerStatus <<- "Win"
        output$playerStatus <- renderText({
          playerStatus
        })
        playerWinTimes <<- playerWinTimes + 1
        output$playerWinTimes <- renderText({
          playerWinTimes
        })
      }
      if (playerScore < opponentScore && opponentScore <= 21) {
        playerStatus <<- "Lose"
        output$playerStatus <- renderText({
          playerStatus
        })
        playerLoseTimes <<- playerLoseTimes + 1
        output$playerLoseTimes <- renderText({
          playerLoseTimes
        })
      }
      if (playerScore == opponentScore && playerScore <= 21) {
        playerStatus <<- "Draw"
        output$playerStatus <- renderText({
          playerStatus
        })
        playerDrawTimes <<- playerDrawTimes + 1
        output$playerDrawTimes <- renderText({
          playerDrawTimes
        })
      }
    }
  })

  # Start Game
  reset_game()
}
