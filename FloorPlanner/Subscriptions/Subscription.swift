//
//

import SwiftUI
import StoreKit

class Subscription : ObservableObject {
    
    @Published var isSubscribed = false
    @Published var showPaymentSheet = false
    @Published var productIds:[String] = [ "B100","B102"]
    @Published var selectedProductId = "A900"
    @Published var inputImages = ["kitchen", "bedroom", "livingRoom","diningRoom"]
    @Published var  outputImages = ["out1", "out2", "out3","out4"]
    @Published var originalImage:UIImage?
    @Published var outputImage:URL?
    @Published var prodFreeTrial = "B100"
    @Published var prodNoTrial = "B102"
    
    public enum StoreError: Error {
        case failedVerification
    }
    
    init(isSubscribed: Bool = false) {
        self.isSubscribed = isSubscribed
        Task{
            await updateCustomerProductStatus()
        }
  
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
         //Check whether the JWS passes StoreKit verification.
         switch result {
         case .unverified:
             //StoreKit parses the JWS, but it fails verification.
             throw StoreError.failedVerification
         case .verified(let safe):
             //The result is verified. Return the unwrapped value.
             return safe
         }
     }
     
     @MainActor
     func updateCustomerProductStatus() async {
         for await result in Transaction.currentEntitlements {
             do {
                 //Check whether the transaction is verified. If it isn’t, catch `failedVerification` error.
                 let transaction = try checkVerified(result)
                 
                 switch transaction.productType {
                     
                     case .autoRenewable:
                     
                     self.isSubscribed = true
                     
                     default:
                         break
                 }
                 //Always finish a transaction.
                 await transaction.finish()
             } catch {
            
                 print(String(localized:  "failed updating products"))
             }
         }
     }
    
    
    func resetImages() {
       inputImages = ["image1", "heaven1","nik","zvolskiy","maage","food"]
       outputImages = ["image2", "heaven2","nik2","zvolskiy2","maage2","food2"]
    }
    
    
}
