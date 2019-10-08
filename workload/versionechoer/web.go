package main

import (
	"context"
	"log"
	"net/http"
	"time"
)

// Response writer spy
// This is simplistic, ignores Hijacker, Flusher etc.
type wrappedResponseWriter struct {
	http.ResponseWriter
	StatusCode int
	BodyBytes  int
}

func (w *wrappedResponseWriter) WriteHeader(statusCode int) {
	w.StatusCode = statusCode
	w.ResponseWriter.WriteHeader(statusCode)
}

func (w *wrappedResponseWriter) Write(data []byte) (int, error) {
	length, err := w.ResponseWriter.Write(data)
	w.BodyBytes += length
	return length, err
}

// Middleware
func newLoggingHandler(h http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Processing %s on %s", r.Method, r.URL.Path)

		st := time.Now()
		ww := &wrappedResponseWriter{w, http.StatusOK, 0}
		h(ww, r)

		log.Printf("Completed processing %s on %s with status code %d, duration %s", r.Method, r.URL.Path, ww.StatusCode, time.Since(st))
	}
}

// Write JSON function
func writeJSON(w http.ResponseWriter, r *http.Request, data []byte) {
	w.Header().Set("Content-Type", "application/json")
	if _, err := w.Write(data); err != nil {
		log.Printf("Write error handling %s on %s: %v", r.Method, r.URL.Path, err)
		// Too late to set status at this stage
	}
}

// Run http server function subject to a context which can be canceled
func runHTTPServer(ctx context.Context, srv *http.Server, pause time.Duration) {
	// Start server, if this fails lets log and panic
	go func() {
		log.Printf("Starting http server %s", srv.Addr)
		if err := srv.ListenAndServe(); err != http.ErrServerClosed {
			log.Fatalf("Http server %s listen and serve error: %v", srv.Addr, err)
		}
		log.Printf("Completed http server %s listen and serve", srv.Addr)
	}()

	// Happy to log and return if errors encountered from this point on
	// Wait for done - OS signal will trigger this
	<-ctx.Done()
	log.Printf("Http server %s about to shutdown", srv.Addr)
	shutCtx, cancel := context.WithTimeout(context.Background(), pause)
	defer cancel()
	// Shutdown - allows in flight requests to complete and prevents new connections
	log.Printf("Http server %s starting shutdown", srv.Addr)
	if err := srv.Shutdown(shutCtx); err != nil {
		log.Printf("Error shutting down http server %s: %v", srv.Addr, err)
		return
	}

	// Close server
	log.Printf("Http server %s starting close", srv.Addr)
	if err := srv.Close(); err != nil {
		log.Printf("Error closing http server %s : %v", srv.Addr, err)
		return
	}

	log.Printf("Http server %s closed", srv.Addr)
}
