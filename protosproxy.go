package main

import (
	"flag"
	"fmt"
	"net/http"
	"net/http/httputil"
	"net/url"
	"os"

	protos "github.com/protosio/protoslib-go"
)

type Prox struct {
	target *url.URL
	proxy  *httputil.ReverseProxy
	appID  string
}

func New(target string) *Prox {
	url, _ := url.Parse(target)

	return &Prox{target: url, proxy: httputil.NewSingleHostReverseProxy(url)}
}

func (p *Prox) handle(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("X-GoProxy", "GoProxy")
	r.Header.Set("Appid", p.appID)
	p.proxy.ServeHTTP(w, r)
}

func main() {
	const (
		defaultPort        = ":9999"
		defaultPortUsage   = "default server port, ':9999'"
		defaultTarget      = "http://protos:8080"
		defaultTargetUsage = "default redirect url, 'http://protos:8080'"
	)

	// flags
	port := flag.String("port", defaultPort, defaultPortUsage)
	url := flag.String("url", defaultTarget, defaultTargetUsage)

	flag.Parse()

	fmt.Printf("server will run on : %s\n", *port)
	fmt.Printf("redirecting to :%s\n", *url)

	// proxy
	proxy := New(*url)

	appID, err := protos.GetAppID()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	proxy.appID = appID

	// server
	http.HandleFunc("/", proxy.handle)
	go http.ListenAndServe(":9996", nil)
	go http.ListenAndServe(":9997", nil)
	go http.ListenAndServe(":9998", nil)
	http.ListenAndServe(*port, nil)
}
