(define (generate-py-assembler filename)
  (call-with-new-output-file filename py-write-assembler))


(define (py-write-assembler port)
  (say-to port "# Generated by Miasma (http://accesscom.com/~darius/software/miasma/)")
  (say-to port)
  (call-with-input-file "python/x86_stub.py"
    (lambda (in)
      (copy-port in port)))
  (say-to port)
  (say-to port (py-enum registers (map register-number registers)))
  (say-to port)
  (for-each (lambda (spec)
              (say-to port (py-gen (spec.mnemonic spec)
                                   (spec.params spec))))
            the-specs))


; Code translation

(define (py-gen mnemonic code-list)
  (let ((vars (py-make-variable-list 
               (foldl + 0 (map py-variable-count code-list)))))
    (py-stmt-macro (py-insn-name mnemonic)
                  vars
                  (py-body vars code-list))))

(define (py-make-variable-list n)
  (map (lambda (k) (string-append "v" (number->string k)))
       (iota n)))

(define (py-body vars code-list)
  (let walking ((code-list code-list)
                (stmts '())
                (vars vars))
    (if (null? code-list)
        stmts
        ((walk-code (car code-list) py-code py-exp) 
         vars
         (lambda (vars cv) 
           (walking (cdr code-list)
                    (cons cv stmts)
                    vars))))))

(define py-code
  (flambda
   ((bytes signed? count exp)
    (with bind ((cv exp))
          (unit 
           (py-exp-stmt
            (py-call (string-append (if signed? "push_i" "push_u")
                                    (integer->string (* 8 count)))
                    cv)))))
   ((swap-args code)
    (swapping code))
   ((mod-r/m e1 e2)
    (with bind ((cv1 e1))
          (with bind ((cv2 e2))
                (unit (py-exp-stmt (py-call "mod_rm" cv1 cv2))))))))

(define py-exp
  (flambda
   ((literal n)
    (unit (py-int-literal n)))
   ((op operator e1 e2)
    (with bind ((cv1 e1))
          (with bind ((cv2 e2))
                (unit (py-binop (symbol->string operator)
                                cv1 
                                cv2)))))
   ((hereafter)
    (unit "hereafter"))
   ((arg . ignore)
    (eating unit))))


; Variables

(define (py-variable-count code)

  (define py-code
    (flambda
     ((bytes signed? count exp)
      exp)
     ((swap-args code)
      code)
     ((mod-r/m e1 e2)
      (with bind ((cv1 e1))
            (with bind ((cv2 e2))
                  (unit (+ cv1 cv2)))))))

  (define py-exp
    (flambda
     ((literal n)
      (unit 0))
     ((op operator e1 e2)
      (with bind ((cv1 e1))
            (with bind ((cv2 e2))
                  (unit (+ cv1 cv2)))))
     ((hereafter)
      (unit 0))
     ((arg . ignore)
      (unit 1))))

  ((walk-code code py-code py-exp) '_
                                  (lambda (_ count) count)))


; Python code constructors

(define (py-enum symbols values)
  (string-join (map (lambda (sym val)
                      (string-append (as-legal-py-identifier 
                                      (symbol->string sym))
                                     " = "
                                     (py-int-literal val)))
                    symbols
                    values)
               (string #\newline)))

(define (py-int-literal n)
  (if (and (<= 0 n) (exact? n))
      (string-append "0x" (number->string n 16))
      (integer->string n)))

(define (py-binop operator cv1 cv2)
  (string-append "(" cv1 " " operator " " cv2 ")"))

(define (py-parenthesize cv)
  (string-append "(" cv ")"))

(define (py-call fn-cv . args-cv)
  (string-append fn-cv
                 "("
                 (string-join args-cv ", ")
                 ")"))

(define (py-exp-stmt cv)
  cv)

(define (py-stmt-macro name vars stmts)
  (string-join `(,(py-declare name vars) 
                 "    global buf"
                 "    hereafter = len(buf)"
                 ,@(map (lambda (stmt) (string-append "    " stmt))
                        stmts))
               (string #\newline)))

(define (py-declare name vars)
  (string-append "def " name "(" (string-join vars ", ") "):"))

(define (py-insn-name mnemonic)
  (as-legal-py-identifier 
   (string-append "" (symbol->string mnemonic))))

; (string) -> string
; Return STR, but munging out any characters that are used in our 
; mnemonics but aren't legal in Python identifiers.
(define (as-legal-py-identifier str)
  (list->string
   (map (lambda (c)
          (case c
            ((#\- #\.) #\_)
            ((#\?) #\c)
            (else c)))
        (filter (lambda (c) (not (memq c '(#\: #\%))))
                (string->list str)))))
