//
//  TransactionListener.swift
//  AiTextToSpeech
//
//  Created by henry on 09/05/2025.
//

import Foundation
import StoreKit

// TransactionListener to handle StoreKit transactions
class TransactionListener {
    static let shared = TransactionListener()
    
    init() {
        // Start listening for transactions when the app launches
        startListening()
    }
    
    func startListening() {
        // Create a task to listen for transaction updates
        Task {
            // Listen for transactions continuously throughout the app's lifetime
            for await result in Transaction.updates {
                do {
                    let transaction = try subscription.checkVerified(result)
                    
                    // Handle the transaction based on its state
                    if transaction.revocationDate == nil {
                        // Transaction is active
                        subscription.isSubscribed = true
                    } else {
                        // Transaction was revoked
                        subscription.isSubscribed = false
                    }
                    
                    // Always finish the transaction
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // A shared subscription instance for the transaction listener
    private var subscription = Subscription()
}
