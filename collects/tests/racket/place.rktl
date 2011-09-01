(load-relative "loadtest.rktl")
(Section 'places)
(require "benchmarks/places/place-utils.rkt")

(place-wait (place/base (p1 ch)
  (printf "Hello from place\n")))


(let ([p (place/base (p1 ch)
          (printf "Hello form place 2\n")
          (exit 99))])
  (test #f place? 1)
  (test #f place? void)
  (test #t place? p)

  (err/rt-test (place-wait 1))
  (err/rt-test (place-wait void))
  (test 99 place-wait p)
  (test 99 place-wait p))

(arity-test dynamic-place 2 2)
(arity-test place-wait 1 1)
(arity-test place-channel 0 0)
(arity-test place-channel-put 2 2)
(arity-test place-channel-get 1 1)
(arity-test place-channel? 1 1)
(arity-test place? 1 1)
(arity-test place-channel-put/get 2 2)
(arity-test processor-count 0 0)

(err/rt-test (dynamic-place "foo.rkt"))
(err/rt-test (dynamic-place null 10))
(err/rt-test (dynamic-place "foo.rkt" 10))
(err/rt-test (dynamic-place '(quote some-module) 'tfunc))

        
(let ([p (place/base (p1 ch)
          (printf "Hello form place 2\n")
          (sync never-evt))])
  (place-kill p)
  (place-kill p)
  (place-kill p))

(for ([v (list #t #f null 'a #\a 1 1/2 1.0 (expt 2 100) 
               "apple" (make-string 10) #"apple" (make-bytes 10)
               (void))])
  (test #t place-message-allowed? v)
  (test #t place-message-allowed? (list v))
  (test #t place-message-allowed? (vector v)))
(for ([v (list (gensym) (string->uninterned-symbol "apple")
               (lambda () 10)
               add1)])
  (test (not (place-enabled?)) place-message-allowed? v)
  (test (not (place-enabled?)) place-message-allowed? (list v))
  (test (not (place-enabled?)) place-message-allowed? (cons 1 v))
  (test (not (place-enabled?)) place-message-allowed? (cons v 1))
  (test (not (place-enabled?)) place-message-allowed? (vector v)))

(report-errs)
