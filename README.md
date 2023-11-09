# Black Jack - Shiny App in R
Week 10 homework for PHP 2560.

## Introduction

This app replicates a simplified version of the game Blackjack. In this version, you will play against another player.
All players start with two cards from the deck and then take turns making decisions. For each turn, you can choose "
hit" (take a card) or "stand" (don't take a card). You "bust" if your card total goes above 21. The game ends when
either all cards are dealt, all players have taken a stand in one round, or all players have gone bust. The object of
the game is to have the highest hand not exceeding 21 at the end of the game.

## Deployment
The app is deployed at [Shiny-BlackJack](https://williamq.shinyapps.io/Shiny-BlackJack/) on shinyapps.io.

### Deploy locally
Go to the repo folder and use the following command to deploy this app locally.
```{shell}
R -e "shiny::runApp('.')"
```