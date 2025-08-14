module MyModule::InvoicePayment {

    use aptos_framework::signer;

    /// Struct representing an invoice
    struct Invoice has store, key {
        payer: address,
        amount_due: u64,
        is_paid: bool,
    }

    /// Function to create an invoice for a payer
    public fun create_invoice(owner: &signer, payer: address, amount: u64) {
        move_to(owner, Invoice {
            payer: payer,
            amount_due: amount,
            is_paid: false
        });
    }

    /// Function for payer to mark invoice as paid
    public fun mark_invoice_paid(payer: &signer, owner_addr: address) acquires Invoice {
        let invoice = borrow_global_mut<Invoice>(owner_addr);

        // Ensure only the correct payer can mark it as paid
        assert!(signer::address_of(payer) == invoice.payer, 1);
        assert!(!invoice.is_paid, 2); // Prevent double marking

        invoice.is_paid = true;
    }
}
