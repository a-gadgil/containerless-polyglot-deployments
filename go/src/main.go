package main

import (
	"encoding/json"
	"net/http"
	"os"
)

type HealthResponse struct {
	Status      string `json:"status"`
	Service     string `json:"service"`
	Hostname    string `json:"hostname"`
	Environment string `json:"environment"`
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	hostname, _ := os.Hostname()
	response := HealthResponse{
		Status:      "UP",
		Service:     "go-host-service",
		Hostname:    hostname,
		Environment: "bare-metal-or-vm",
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/health", healthHandler)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	println("Starting Go host-native service on port " + port)
	if err := http.ListenAndServe(":"+port, mux); err != nil {
		panic(err)
	}
}