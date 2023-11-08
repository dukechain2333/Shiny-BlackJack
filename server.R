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

# Define server logic required to draw a histogram
function(input, output, session) {

  observeEvent(input$restart, {
    session$reload()
  })

  # Initialize deck
  deck <- sample(rep(1:13, 4), replace = FALSE)

  # Deal two cards to each player
  hands <- list(me_player = deck[1:2], opponent = deck[3:4])
  deck <- deck[-c(1:4)]

  output$me_player <- insertUI(
    selector = "#yourHand",
    ui = lapply(hands$me_player, function(card) {
      tags$div(
        style = "margin: 1vh; border-color: black; border-style: solid; display: flex; justify-content: center; align-items: center; height: 10vh; width: 5vh;",
        id = paste0("me_player", card),
        tags$p(card)
      )
    })
  )
  output$opponent <- insertUI(
    selector = "#opponentHand",
    ui = lapply(hands$opponent, function(card) {
      tags$div(
        style = "margin: 1vh; border-color: black; border-style: solid; display: flex; justify-content: center; align-items: center; height: 10vh; width: 5vh;",
        id = paste0("opponent", card),
        tags$p(card)
      )
    })
  )


}
