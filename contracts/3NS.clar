(use-trait nft-trait .nft-implementation.nft-trait)

(define-data-var whitelist (set principal) (set))
(define-data-var name-registry (map uint principal) (map))
(define-constant did-method "did:stacks:")

(define-private (is-whitelisted (wallet principal))
  (set-member? (var-get whitelist) wallet))

(define-private (is-name-available (token-id uint))
  (not (is-some (map-get? name-registry ((name token-id))))))

(define-public (add-to-whitelist (wallet principal))
  (begin
    (asserts! (is-eq tx-sender (contract-owner)) (err u1)) ; Only contract owner can add to whitelist
    (var-set whitelist (set-insert (var-get whitelist) wallet))
    (ok true)))

(define-public (register-name (token-id uint) (wallet principal))
  (begin
    (asserts! (is-whitelisted tx-sender) (err u2)) ; Only whitelisted wallets can register names
    (asserts! (is-name-available token-id) (err u3)) ; Name must be available
    (asserts! (is-eq (unwrap! (contract-call? .nft-implementation get-owner token-id) (err u4)) wallet) (err u5)) ; Wallet must own the NFT
    (map-set name-registry ((name token-id)) wallet)
    (ok true)))

(define-public (send-to-name (token-id uint) (amount uint))
  (let ((recipient (unwrap! (map-get? name-registry ((name token-id))) (err u6)))) ; Name must be registered
    (stx-transfer? amount tx-sender recipient)))

(define-read-only (get-wallet-by-name (token-id uint))
  (map-get? name-registry ((name token-id))))

(define-read-only (get-names-by-wallet (wallet principal))
  (map-filter name-registry (lambda ((name principal)) (is-eq wallet principal))))
