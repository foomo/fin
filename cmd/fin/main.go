package main

import (
	"net/http"

	"github.com/foomo/keel"
)

func main() {
	svr := keel.NewServer(
		keel.WithHTTPZapService(true),
		keel.WithHTTPViperService(true),
		keel.WithHTTPPrometheusService(true),
	)

	l := svr.Logger()

	svs := newService()

	svr.AddService(
		keel.NewServiceHTTP(l, "demo", ":8080", svs),
	)

	svr.Run()
}

func newService() *http.ServeMux {
	s := http.NewServeMux()
	s.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte("OK"))
	})
	return s
}
