package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"syscall"
)

func createShutdownContext() context.Context {
	// Listen on SIGINT or SIGTERM
	sigs := make(chan os.Signal)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	ctx, cancel := context.WithCancel(context.Background())

	go func() {
		sig := <-sigs
		log.Printf("Received signal [%s], beginning shutdown", sig)
		cancel()
		log.Printf("Handled signal [%s], exiting", sig)
	}()

	return ctx
}
