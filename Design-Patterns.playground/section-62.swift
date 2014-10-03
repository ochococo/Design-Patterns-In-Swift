let context = Context()
(context.isAuthorized, context.userId)
context.changeStateToAuthorized(userId: "admin")
(context.isAuthorized, context.userId) // now logged in as "admin"
context.changeStateToUnauthorized()
(context.isAuthorized, context.userId)