Simple Invoice Payment (Aptos Move)

Description
A minimal Move smart contract that lets a seller create a single on-chain invoice for a specified payer and amount, and lets only that payer mark the invoice as paid. It’s intentionally tiny (2 functions) to keep the logic clear and easy to audit.

Vision
Make peer-to-peer invoicing on Aptos dead simple: a seller posts an invoice to their account; the designated payer confirms payment. This contract is a foundation for lightweight billing flows, proofs of payment, and integrations where you need a trusted “paid/unpaid” flag on-chain.

Future Scope
Support multiple invoices per seller (add id/map storage).

Integrate actual coin transfers (e.g., AptosCoin) and enforce exact amount.

Emit events for creation and payment to ease indexing/UX.

Add expiry/cancel and refund paths.

Role-based access (e.g., allow a merchant admin to manage invoices).

Off-chain indexer & simple UI to list and pay invoices.

Contract Details
<img width="586" height="431" alt="image" src="https://github.com/user-attachments/assets/b121f7e3-d3e9-4765-8d9d-57897f638846" />

Module Name: MyModule::InvoicePayment

Deployed Address (module owner): 0x39eb61a290cc95086a33315e80d3a81a06897965a2be6dbd5dce5330df42ef43
Full Module ID:0x39eb61a290cc95086a33315e80d3a81a06897965a2be6dbd5dce5330df42ef43 ::InvoicePayment

If you publish from a different account, update the address above to your publisher address.

Code (for reference)
move
Copy
Edit
module MyModule::InvoicePayment {
    use aptos_framework::signer;

    struct Invoice has store, key {
        payer: address,
        amount_due: u64,
        is_paid: bool,
    }

    public fun create_invoice(owner: &signer, payer: address, amount: u64) {
        move_to(owner, Invoice { payer, amount_due: amount, is_paid: false });
    }

    public fun mark_invoice_paid(payer: &signer, owner_addr: address) acquires Invoice {
        let invoice = borrow_global_mut<Invoice>(owner_addr);
        assert!(signer::address_of(payer) == invoice.payer, 1);
        assert!(!invoice.is_paid, 2);
        invoice.is_paid = true;
    }
}
Notes

create_invoice stores the invoice under the seller’s (owner’s) account.

mark_invoice_paid can only be called by the designated payer and only once.
