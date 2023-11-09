#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

fluidPage(

  tags$style(
    HTML("
      #restart {
        color: white;            /* Text color */
        background-color: green;   /* Background color */
      }
      #nextRound {
        color: white;            /* Text color */
        background-color: red;   /* Background color */
      },
    ")
  ),

  # Application title
  titlePanel("Welcome to Black Jack!"),

  sidebarLayout(
    sidebarPanel(
      h2("Introduction"),
      p("This app replicates a simplified version of the game Blackjack. In this version, you will play against another player.
      All players start with two cards from the deck and then take turns making decisions. For each turn, you can choose \"hit\" (take a card) or \"stand\" (don\'t take a card).
      You \"bust\" if your card total goes above 21. The game ends when either all cards are dealt, all players have taken a stand in one round, or all players have gone bust.
      The object of the game is to have the highest hand not exceeding 21 at the end of the game."),

      h2("Control Panel"),
      h3("Game Controls"),
      actionButton("restart", "Restart Game", width = "100%"),
      br(),
      br(),
      actionButton("nextRound", "Next Round", width = "100%"),
      selectInput("hardSelect", h3("Select Difficulty"),
                  choices = list("I want to win" = 1,
                                 "Test my luck" = 2),
                  selected = 1),
      p("Remember to click \"Restart Game\" after changing difficulty!"),
      h3("Player Controls"),
      actionButton("hit", "Hit", width = "100%"),
      br(),
      br(),
      actionButton("stand", "Stand", width = "100%")
    ),

    # Show current hands and scores
    mainPanel(
      column(width = 12,
             div(id = "opponentHand", style = "display: flex; align-items: center; height: 35vh"),
             h3("Your Opponent", align = "center"),
      ),
      fluidRow(
        column(width = 2,
               h3("Yours: "),
               verbatimTextOutput("playerScore")
        ),
        column(width = 2,
               h3("Opponents: "),
               verbatimTextOutput("opponentScore")
        ),
        column(width = 2,
               h3("Status: "),
               verbatimTextOutput("playerStatus")
        ),
        column(width = 2,
               h3("Win: "),
               verbatimTextOutput("playerWinTimes")
        ),
        column(width = 2,
               h3("Lose: "),
               verbatimTextOutput("playerLoseTimes")
        ),
        column(width = 2,
               h3("Draw: "),
               verbatimTextOutput("playerDrawTimes")
        )
      ),
      column(width = 12,
             h3("Your Hand", align = "center"),
             div(id = "yourHand", style = "display: flex; align-items: center; height: 35vh"),
      )
    )
  )
)
