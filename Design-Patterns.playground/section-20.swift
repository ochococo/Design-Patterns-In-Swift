var gameState = GameState()
gameState.restoreFromMemento(CheckPoint.restorePreviousState())

gameState.chapter = "Black Mesa Inbound"
gameState.weapon = "Crowbar"
CheckPoint.saveState(gameState.toMemento())

gameState.chapter = "Anomalous Materials"
gameState.weapon = "Glock 17"
gameState.restoreFromMemento(CheckPoint.restorePreviousState())

gameState.chapter = "Unforeseen Consequences"
gameState.weapon = "MP5"
CheckPoint.saveState(gameState.toMemento(), keyName: "gameState2")

gameState.chapter = "Office Complex"
gameState.weapon = "Crossbow"
CheckPoint.saveState(gameState.toMemento())

gameState.restoreFromMemento(CheckPoint.restorePreviousState(keyName: "gameState2"))