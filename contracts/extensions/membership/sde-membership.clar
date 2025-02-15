;;     _____________  _______ _________  ___  ___  ____  ____
;;     / __/_  __/ _ |/ ___/ //_/ __/ _ \/ _ \/ _ |/ __ \/ __/
;;     _\ \  / / / __ / /__/ ,< / _// , _/ // / __ / /_/ /\ \  
;;    /___/ /_/ /_/ |_\___/_/|_/___/_/|_/____/_/ |_\____/___/  
;;                                                          
;;     _____  _____________  ______________  _  __           
;;    / __/ |/_/_  __/ __/ |/ / __/  _/ __ \/ |/ /           
;;   / _/_>  <  / / / _//    /\ \_/ // /_/ /    /            
;;  /___/_/|_| /_/ /___/_/|_/___/___/\____/_/|_/             
;;                                                           

;; Title: SDE006 DAO Membership
;; Author: StackerDAO Dev Team
;; Depends-On: 
;; Synopsis:
;; This extension allows members to be added manually when creating the DAO.
;; Description:
;; An extension meant for creating safes or small groups of members to perform actions.

(use-trait proposal-trait .proposal-trait.proposal-trait)

(impl-trait .member-trait.member-trait)
(impl-trait .extension-trait.extension-trait)

(define-constant ERR_UNAUTHORIZED (err u2900))
(define-constant ERR_NOT_A_MEMBER (err u2901))
(define-constant ERR_MEMBER_BLACKLISTED (err u2902))

(define-map Members principal bool)
(define-map BlacklistMembers principal bool)

;; --- Authorization check

(define-public (is-dao-or-extension)
  (ok (asserts! (or (is-eq tx-sender .executor-dao) (contract-call? .executor-dao is-extension contract-caller)) ERR_UNAUTHORIZED))
)

;; --- Internal DAO functions

(define-public (set-member (who principal) (member bool))
  (begin
    (try! (is-dao-or-extension))
    (asserts! (is-none (map-get? BlacklistMembers who)) ERR_MEMBER_BLACKLISTED)
    (ok (map-set Members who member))
  )
)

(define-public (set-blacklist (who principal) (member bool))
  (begin
    (try! (is-dao-or-extension))
    (ok (map-set BlacklistMembers who member))
  )
)

;; --- Public functions

;; --- Read only functions

(define-read-only (is-member (who principal))
  (if (is-blacklisted who)
    (ok false)
    (ok (default-to false (map-get? Members who)))
  )
)

(define-read-only (is-blacklisted (who principal))
  (default-to false (map-get? BlacklistMembers who))
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
  (ok true)
)
