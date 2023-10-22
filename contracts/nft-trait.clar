(define-trait nft-trait 
  ((get-owner (uint) (response principal uint))
   (transfer (uint principal) (response bool uint)))) ; should be already defined?