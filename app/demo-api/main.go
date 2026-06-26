package main

import (
	"log/slog"
	"os"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/collectors"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	// logger
	logger := slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
		Level: slog.LevelInfo,
	}))
	slog.SetDefault(logger)

	reg := prometheus.NewRegistry()
	reg.MustRegister(
		collectors.NewGoCollector(),
		collectors.NewProcessCollector(collectors.ProcessCollectorOpts{}),
	)

	httpRequests := prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "http_requests_total",
			Help: "Total HTTP requests handled, partitioned by method, route, and status.",
		},
		[]string{"method", "route", "status"},
	)
	httpDuration := prometheus.NewHistogramVec(
		prometheus.HistogramOpts{
			Name:    "http_request_duration_seconds",
			Help:    "HTTP request duration in seconds.",
			Buckets: prometheus.DefBuckets,
		},
		[]string{"method", "route", "status"},
	)
	reg.MustRegister(httpRequests, httpDuration)

	gin.SetMode(gin.ReleaseMode)
	r := gin.New()
	r.Use(gin.Recovery())
	r.Use(observability(httpRequests, httpDuration))

	// GET /api/
	r.GET("/api/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"app":            "k8s-multi-cloud",
			"version":        os.Getenv("VERSION"),
			"cloud_provider": os.Getenv("CLOUD_PROVIDER"),
		})
	})

	// GET /env/
	r.GET("/env/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"VERSION":        os.Getenv("VERSION"),
			"CLOUD_PROVIDER": os.Getenv("CLOUD_PROVIDER"),
		})
	})

	// GET /healthz/
	r.GET("/healthz", func(c *gin.Context) {
		c.String(200, "ok")
	})

	// GET /metrics/
	r.GET("/metrics", gin.WrapH(promhttp.HandlerFor(reg, promhttp.HandlerOpts{Registry: reg})))

	slog.Info("starting demo-api",
		"addr", ":8080",
		"version", os.Getenv("VERSION"),
		"cloud_provider", os.Getenv("CLOUD_PROVIDER"),
	)
	if err := r.Run(":8080"); err != nil {
		slog.Error("server exited", "err", err)
		os.Exit(1)
	}
}

func observability(reqs *prometheus.CounterVec, dur *prometheus.HistogramVec) gin.HandlerFunc {
	return func(c *gin.Context) {
		path := c.Request.URL.Path
		if path == "/metrics" || path == "/healthz" {
			c.Next()
			return
		}

		start := time.Now()
		c.Next()
		elapsed := time.Since(start)

		route := c.FullPath()
		if route == "" {
			route = "unknown"
		}
		status := strconv.Itoa(c.Writer.Status())

		reqs.WithLabelValues(c.Request.Method, route, status).Inc()
		dur.WithLabelValues(c.Request.Method, route, status).Observe(elapsed.Seconds())

		slog.Info("http_request",
			"method", c.Request.Method,
			"route", route,
			"path", path,
			"status", c.Writer.Status(),
			"latency_ms", elapsed.Milliseconds(),
			"client_ip", c.ClientIP(),
		)
	}
}
