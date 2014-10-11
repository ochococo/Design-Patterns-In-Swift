var gameState = GameState()
gameState.gameLevel = 2
gameState.playerScore = 200

// Saves state: {gameLevel 2 playerScore 200}
CheckPoint.saveState(gameState.saveToMemeto())

gameState.gameLevel = 3
gameState.gameLevel = 250

// Restores state: {gameLevel 2 playerScore 200}
gameState.restoreFromMemeto(CheckPoint.restorePreviousState())

gameState.gameLevel = 4

// Saves state - gameState2: {gameLevel 4 playerScore 200}
CheckPoint.saveState(gameState.saveToMemeto(), keyName: "gameState2")

gameState.gameLevel = 5
gameState.playerScore = 300

// Saves state - gameState3: {gameLevel 5 playerScore 300}
CheckPoint.saveState(gameState.saveToMemeto(), keyName: "gameState3")

// Restores state - gameState2: {gameLevel 4 playerScore 200}
gameState.restoreFromMemeto(CheckPoint.restorePreviousState(keyName: "gameState2"))