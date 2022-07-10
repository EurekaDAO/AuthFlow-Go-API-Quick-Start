package main

import (
	"fmt"

	"github.com/EurekaDAO/fcl-go-api-quick-start/internal/controllers"
	"github.com/EurekaDAO/fcl-go-api-quick-start/internal/database"
	"github.com/EurekaDAO/fcl-go-api-quick-start/internal/middlewares"
	"github.com/gin-gonic/gin"
)

func main() {
	// Load Configurations from config.json using Viper
	LoadAppConfig()

	// Initialize Database
	database.Connect(AppConfig.ConnectionString)
	database.Migrate()

	// Initialize Router
	router := initRouter()
	router.Run(fmt.Sprintf(":%v", AppConfig.Port))
}

func initRouter() *gin.Engine {
	router := gin.Default()
	api := router.Group("/api")
	{
		api.POST("/token", controllers.GenerateToken)
		api.POST("/user/register", controllers.RegisterUser)
		secured := api.Group("/secured").Use(middlewares.Auth())
		{
			secured.GET("/ping", controllers.Ping)
		}
	}
	return router
}
