package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"time"
)

var (
	// This will be set at build time based on the VERSION file content, see the Makefile
	version = "1.0"
)

func main() {
	// Lets include some richer log prefix info
	log.SetFlags(log.Llongfile | log.Ldate | log.Ltime | log.LUTC)
	log.Printf("Version: %s", version)

	// Port flag, defaulted but can override
	port := flag.Int("port", 5000, "Port to listen on")

	mux := http.NewServeMux()
	mux.HandleFunc("/", newLoggingHandler(func(w http.ResponseWriter, r *http.Request) {
		// Simulate work with a delay
		<-time.After(150 * time.Millisecond)
		json := fmt.Sprintf(`{"version": "%s" }`, version)
		writeJSON(w, r, []byte(json))
	}))
	mux.HandleFunc("/liveness", newLoggingHandler(func(w http.ResponseWriter, r *http.Request) {
		json := `{"status": "ok"}`
		writeJSON(w, r, []byte(json))
	}))
	mux.HandleFunc("/readiness", newLoggingHandler(func(w http.ResponseWriter, r *http.Request) {
		json := `{"status": "ok"}`
		writeJSON(w, r, []byte(json))
	}))

	addr := fmt.Sprintf(":%d", *port)
	srv := &http.Server{
		Addr:         addr,
		Handler:      mux,
		IdleTimeout:  120 * time.Second,
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 10 * time.Second,
	}

	ctx := createShutdownContext()
	go runHTTPServer(ctx, srv, 2*time.Second)

	log.Println("Waiting on shutdown signal")
	<-ctx.Done()
	<-time.After(3 * time.Second)
	log.Println("Exiting")
}
