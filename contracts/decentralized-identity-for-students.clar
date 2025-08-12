;; Decentralized Identity for Students
;; Minimal contract with two core functions: register-student and get-student-info

;; Data storage
(define-map students
  principal
  {
    name: (string-ascii 50),
    course: (string-ascii 50)
  }
)

;; Errors
(define-constant err-already-registered (err u100))
(define-constant err-not-registered (err u101))
(define-constant err-invalid-input (err u102))

;; Function 1: Register student identity
(define-public (register-student (name (string-ascii 50)) (course (string-ascii 50)))
  (begin
    (asserts! (not (is-some (map-get? students tx-sender))) err-already-registered)
    (asserts! (and (> (len name) u0) (> (len course) u0)) err-invalid-input)
    (map-set students tx-sender { name: name, course: course })
    (ok "Student registered successfully")
  )
)

;; Function 2: Get student info
(define-read-only (get-student-info (student principal))
  (match (map-get? students student)
    student-data (ok student-data)
    (err err-not-registered)
  )
)
