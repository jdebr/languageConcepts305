;  Joseph DeBruycker
;  Lab 3
;  CSCI 305
;  Spring 2015
#lang scheme


;  Warmup
(define (f lst)
	; (a) ;  Test to see if lst is empty
	(if (null? lst)
		; (b) ; If it is, return an empty list
		'()
		; (c) ; If it isn't, pull off the first element, increment it by 1
		;		and return that value concatenated with the recursive call
		;		on the remaining elements of the list
		(cons (+ 1 (car lst)) (f (cdr lst)))
	)
)

;test
;(display(f '(3 1 4 1 5 9)))



; Member? function
(define (member? e lst)
	; Test for null, if you have arrived here e is not in lst
	(if (null? lst)
		#f
		; otherwise, check if car(lst) is e
		(if (eqv? e (car lst))
			#t
			; if it isn't, recurse on cdr(lst)
			(member? e (cdr lst))
		)
	)
)

;test
;(define a '(a b c d e))
;(display(member? 'e '(a b c d e)))
;(display (member? (car a) (cdr a)))
;(display (member? 'one '(1 2 3 4)))



; Set? function
(define (set? lst)
	; Test for null, if null return true because null set is well formed
	(if (null? lst)
		#t
		; otherwise, check to see if cdr(lst) is null
		(if (null? (cdr lst))
			; return true because single element set is well formed
			#t
			; otherwise, check for repetition with member? function
			(if (member? (car lst) (cdr lst))
				; return false if an element is in the set twice
				#f
				; otherwise, recurse on cdr(lst)
				(set? (cdr lst))
			)
		)
	)
)

;test
;(display (car a))
;(display (cdr a))
;(display (set? a))
;(display (set? (cdr a)))
;(display (set? '(1)))
;(display (set? '(it was the best of times, it was the worst of times)))



; Makeset helper function for Union and Intersect functions.  This helper
; function takes a list and eliminates any repeat elements, returning a
; proper mathematical set consisting of the unique elements from the list
(define (makeset lst)
	; base case:  if the list is a set then return it
	(if (set? lst)
		lst
		; otherwise, test if the first element appears more than once
		(if (member? (car lst) (cdr lst))
			; if it does, discard it and recurse
			(makeset (cdr lst))
			; if it doesn't, move it to the back of the list and recurse
			(makeset (append (cdr lst) (list (car lst))))
		)
	)
)



; Union function
(define (union lst1 lst2)
	; check to see if we need our helper makeset
	(if (set? lst1)
		; ...still checking
		(if (set? lst2)
			; Test for lst2 null - base case
			(if (null? lst2)
				; Return lst1 to complete recursive call returns
				lst1
				; Otherwise, check if first element of lst2 is not in lst1
				(if (not (member? (car lst2) lst1))
					; Append it to recursion on lst1 and cdr lst2
					(append (union lst1 (cdr lst2)) (list (car lst2)))
					; Otherwise discard it and recurse on cdr(lst2)
					(union lst1 (cdr lst2))
				)
			)
			; call makeset on lst2 if needed
			(union lst1 (makeset lst2))
		)
		; call makeset on lst1 if needed
		(union (makeset lst1) lst2)
	)
)

; tests
;(display (union '(1 2 3) '(3 4 5)))
;(display (union '(green eggs and) '(ham)))



; Intersect function
(define (intersect lst1 lst2)
	; check to see if we need our helper makeset
	(if (set? lst1)
		; ...still checking
		(if (set? lst2)
			; Test if ls11 is null, base case 
			(if (null? lst1)
				'()
				; Test if an element of lst1 is also an element of lst2
				(if (member? (car lst1) lst2)
					; Return that element concatenated with all such elements
					(cons (car lst1) (intersect (cdr lst1) lst2))
					; If it isn't discard it and recurse
					(intersect (cdr lst1) lst2)
				)
			)
			; call makeset on lst2 if needed
			(intersect lst1 (makeset lst2))
		)
		; call makeset on lst1 if needed
		(intersect (makeset lst1) lst2)
	)
)

; tests
; (display (intersect '(1 2 3 4 5) '(3 4 5 6 7)))
; (display (intersect '(stewed tomatoes and macaroni) '(macaroni and cheese)))



; Makeflat helper function for flatten, flattens a single list
(define (makeflat lst)
	; Base case
	(if (null? lst)
		; Return empty list
		'()
		; Otherwise test if first element is embedded list
		(if (list? (car lst))
			; Recurse on it if it is
			(append (makeflat (car lst)) (cdr lst))
			; Otherwise append it and recurse on the cdr
			(append (list(car lst)) (makeflat (cdr lst)))
		)
	)
)

; Flatten function uses Union, Makeflat, and Makeset to combine two lists
; and eliminate all embedded list levels to make one mathematical set with no
; repeated elements
(define (flatten lst1 lst2)
	; call makeset, union, and makeflat on the two lists
	(makeset (union (makeflat lst1) (makeflat lst2)))
)

;tests
;(display (flatten '(1 2 (3 4) 5) '(5 6 (7 (8 9) 10 ) 11) ))
;(display (flatten '(1 (2 3) 5) '(8 (13 (21 34) 55))))