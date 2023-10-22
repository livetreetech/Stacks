(define-non-fungible-token nft uint) ; should be already defined?

(define-public (mint (recipient principal) (token-id uint))
  (begin
    (asserts! (is-eq tx-sender (contract-owner)) (err u1)) ; Only contract owner can mint
    (nft-mint? nft token-id recipient)
    (ok true)))

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? nft token-id)))

(define-public (transfer (token-id uint) (new-owner principal))
  (nft-transfer? nft token-id tx-sender new-owner))

(impl-trait .nft-trait.nft-trait)