import StoreKit
//
//  PurchaseView.swift
//  ai photo answer
//
//  Created by Shafiq Kasumba on 04/04/2025.
//
//
//
import SwiftUI

struct MyPurchaseView: View {

    @EnvironmentObject var subscription: Subscription
    @StateObject var layout: LayoutManager = LayoutManager()

    // Initialize transaction listener when the app starts
    private let transactionListener = TransactionListener.shared

    @State private var shakeDegrees = 0.0
    @State private var shakeZoom = 0.9
    @State private var showCloseButton = false
    @State private var progress: CGFloat = 0.0

    @Binding var isPresented: Bool

    @State var showNoneRestoredAlert: Bool = false
    @State private var showTermsActionSheet: Bool = false

    @State private var selectedProductId: String = ""

    let color: Color = Color.accentColor

    private let allowCloseAfter: CGFloat = 5.0  //time in seconds until close is allows

    var hasCooldown: Bool = true

    @State private var productDetails: [PurchaseProductDetails] = []
    @State private var isPurchasing: Bool = false
    @State private var isFetchingProducts: Bool = true
    @State private var errorMessage: String = ""
    @State private var showErrorAlert: Bool = false
    @State private var subscriptionSubText = ""

    // Function to fetch product details from App Store - UPDATED
    func fetchProducts() {
        Task {
            do {
                // Reset state
                await MainActor.run {
                    isFetchingProducts = true
                    productDetails = []
                }

                // Request products from the App Store
                let products = try await Product.products(for: Set(subscription.productIds))

                // Transform StoreKit products into our model
                let details = products.map { product -> PurchaseProductDetails in
                    // Log subscription details to debug
                    //                    if let subscription = product.subscription {
                    //                        print("Product ID: \(product.id)")
                    //                        print("Period Unit: \(subscription.subscriptionPeriod.unit)")
                    //                        print("Period Value: \(subscription.subscriptionPeriod.value)")
                    //                    }
                    //
                    // Determine duration type based on subscription period
                    var duration = "unknown"
                    var durationPlanName = "Subscription"
                    var priceDurationInfo = "unknown"

                    var hasFreeTrial = false
                    var trialPeriod: String? = nil

                    if let subscription = product.subscription {

                        switch subscription.subscriptionPeriod.unit {

                        case .week, .day:
                            duration = "week"
                            durationPlanName = String(localized: "Weekly")
                            priceDurationInfo = String(localized: "Per Week")

                        case .month:
                            duration = "month"
                            durationPlanName = String(localized: "Monthly")
                            priceDurationInfo = String(localized: "Per Month")
                        case .year:
                            duration = "year"
                            durationPlanName = String(localized: "Yearly")
                            priceDurationInfo = String(localized: "Per Year")
                        @unknown default:
                            duration = "unknown"
                        }

                        // Check for introductory offer (Free Trial)
                        if let introductoryOffer = subscription.introductoryOffer,
                            introductoryOffer.paymentMode == .freeTrial
                        {
                            hasFreeTrial = true

                            // Calculate trial period string
                            let unitCount = introductoryOffer.period.value
                            let unitName: String
                            switch introductoryOffer.period.unit {
                            case .day:
                                unitName =
                                    unitCount == 1
                                    ? String(localized: "Day") : String(localized: "Days")
                            case .week:
                                unitName =
                                    unitCount == 1
                                    ? String(localized: "Week") : String(localized: "Weeks")
                            case .month:
                                unitName =
                                    unitCount == 1
                                    ? String(localized: "Month") : String(localized: "Months")
                            case .year:
                                unitName =
                                    unitCount == 1
                                    ? String(localized: "Year") : String(localized: "Years")
                            @unknown default: unitName = ""
                            }
                            trialPeriod = "\(unitCount) \(unitName)"

                            // Override plan name for trial products if desired, or keep "Weekly" etc.
                            // For consistency with old logic "3-Day Trial"
                            durationPlanName = "\(trialPeriod!) \(String(localized: "Trial"))"
                        }
                    }

                    return PurchaseProductDetails(
                        price: product.displayPrice,
                        productId: product.id,
                        duration: duration,
                        durationPlanName: durationPlanName,
                        priceDurationInfo: priceDurationInfo,
                        hasFreeTrial: hasFreeTrial,
                        trialPeriod: trialPeriod
                    )
                }

                // Sort products by duration (weekly, monthly, yearly)
                let sortedDetails = details.sorted { first, second in
                    let durationOrder = ["week": 1, "month": 2, "year": 3]
                    return durationOrder[first.duration] ?? 0 < durationOrder[second.duration] ?? 0
                }

                //
                //                for detail in sortedDetails {
                //                    print("\(detail.productId): \(detail.durationPlanName) - \(detail.duration) - \(detail.price)")
                //                }

                // Update the UI with the fetched products
                await MainActor.run {
                    productDetails = sortedDetails
                    isFetchingProducts = false
                    selectedProductId = subscription.productIds[0]
                    //                    // Default to selecting the yearly product
                    //                    if let yearlyProduct = sortedDetails.first(where: { $0.duration == "year" }) {
                    //                        selectedProductId = yearlyProduct.productId
                    //                    } else if let lastId = sortedDetails.last?.productId {
                    //
                    //                    }
                }
            } catch {
                await MainActor.run {
                    isFetchingProducts = false
                    errorMessage =
                        "Failed to load subscription options: \(error.localizedDescription)"
                    showErrorAlert = true
                    print("Error fetching products: \(error)")
                }
            }
        }
    }

    var callToActionText: String {

        if let product = productDetails.first(where: { $0.id == selectedProductId }),
            product.hasFreeTrial
        {
            return String(localized: "Try For Free")
        } else {
            return String(localized: "Unlock Now")
        }

    }

    // Function to calculate reference price (weekly × 4 for monthly, weekly × 52 for yearly)
    func calculateReferencePrice(for duration: String) -> Double? {
        if let weeklyPriceString = productDetails.first(where: { $0.duration == "week" })?.price {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency

            if let number = formatter.number(from: weeklyPriceString) {
                let weeklyPriceDouble = number.doubleValue

                if duration == "month" {
                    return weeklyPriceDouble * 4  // 4 weeks in a month
                } else if duration == "year" {
                    return weeklyPriceDouble * 52  // 52 weeks in a year
                }
            }
        }
        return nil
    }

    // Modified function to calculate yearly discount based on weekly × 52
    func calculatePercentageSaved(for duration: String) -> Int {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        if let weeklyPriceString = productDetails.first(where: { $0.duration == "week" })?.price,
            let weeklyNumber = formatter.number(from: weeklyPriceString)
        {
            let weeklyPriceDouble = weeklyNumber.doubleValue

            if duration == "year",
                let yearlyPriceString = productDetails.first(where: { $0.duration == "year" })?
                    .price,
                let yearlyNumber = formatter.number(from: yearlyPriceString)
            {

                let yearlyPriceDouble = yearlyNumber.doubleValue
                let yearlyFromWeekly = weeklyPriceDouble * 52  // 52 weeks in a year

                let saved = Int(100 - ((yearlyPriceDouble / yearlyFromWeekly) * 100))
                if saved > 0 {
                    return saved
                }
            }
        }

        return 70  // Fallback value for yearly discount
    }

    var isFreeTrialBinding: Binding<Bool> {
        Binding<Bool>(
            get: {
                if let product = productDetails.first(where: { $0.id == selectedProductId }) {
                    return product.hasFreeTrial
                }
                return false
            },
            set: { newValue in
                // Find a product that matches the free trial preference
                if let targetProduct = productDetails.first(where: {
                    $0.hasFreeTrial == newValue
                }) {
                    withAnimation {
                        selectedProductId = targetProduct.id
                    }
                }
            }
        )
    }

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                headerView

                ImagePairView()

                featuresView

                Spacer()

                purchaseOptionsView

                Spacer()

                footerView
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea()
        .frame(maxWidth: 500)
        .preferredColorScheme(.dark)
        // Removed onChange of isFreeTrial as logic is now in binding setter

        .onAppear {
            // First check if already subscribed
            Task {
                // Ensure we've initialized the transaction listener
                _ = transactionListener

                // Check current subscription status
                await subscription.updateCustomerProductStatus()

                /* if subscription.isSubscribed {
                     DispatchQueue.main.async {
                         isPresented = false
                     }
                     return
                 }*/

                // Fetch products from the App Store
                fetchProducts()

                // Start the cooldown timer for the close button
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeIn(duration: allowCloseAfter)) {
                        self.progress = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + allowCloseAfter) {
                        withAnimation {
                            showCloseButton = true
                        }
                    }
                }
            }
        }
        .alert(errorMessage, isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        }
        .onChange(of: subscription.isSubscribed) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPresented = false
                }
            }
        }

    }

    @ViewBuilder
    var headerView: some View {
        HStack {
            Spacer()

            if hasCooldown && !showCloseButton {
                // Modern circular progress view
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .opacity(0.1 + 0.1 * self.progress)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 28, height: 28)

            } else {
                // Close button
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 32)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 60)
        .padding(.trailing)
    }

    @ViewBuilder
    var featuresView: some View {
        VStack {
            Text("Unlock unlimited access")
                .font(.title)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading) {

                PurchaseFeatureView(
                    title: String(localized: "Unlimited Image generations"),
                    icon: "document.badge.plus", color: color)

                PurchaseFeatureView(
                    title: String(localized: "Access to all design styles"),
                    icon: "camera.filters", color: color)

                PurchaseFeatureView(
                    title: String(localized: "Remove watermark"), icon: "circle.slash", color: color
                )

                PurchaseFeatureView(
                    title: String(localized: "No Advertisements"), icon: "eraser.line.dashed",
                    color: color)

            }
            .font(.system(size: 19))

            .padding(.top)
        }.fontWeight(.semibold)

            .onChange(of: selectedProductId) { oldValue, newValue in
                for productDetail in productDetails {
                    if productDetail.duration == "week" && selectedProductId == productDetail.id {

                        if productDetail.hasFreeTrial, let trialPeriod = productDetail.trialPeriod {

                            subscriptionSubText =
                                "\(trialPeriod) \(String(localized: "Free, then")) \(productDetail.price) / \(productDetail.duration)"
                        } else {

                            subscriptionSubText =
                                " \(productDetail.price) / \(productDetail.duration) "
                        }
                    }

                    if productDetail.duration == "year" && selectedProductId == productDetail.id {

                        subscriptionSubText = "\(productDetail.price) / \(productDetail.duration)"
                    }
                }
            }
    }

    @ViewBuilder
    var purchaseOptionsView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {

                ForEach(productDetails) { productDetails in
                    Button {
                        withAnimation {
                            selectedProductId = productDetails.productId
                        }
                        // Manual sync removed as isFreeTrialBinding handles it

                    } label: {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(productDetails.durationPlanName)
                                        .font(.headline.bold())
                                    if productDetails.durationPlanName == "Weekly"
                                        || productDetails.durationPlanName == "Monthly"
                                    {

                                        Text(
                                            productDetails.price + " "
                                                + productDetails.priceDurationInfo
                                        )
                                        .foregroundStyle(.white)
                                    } else {
                                        HStack(spacing: 0) {
                                            if let referencePrice = calculateReferencePrice(
                                                for: productDetails.duration),
                                                let referencePriceFormatted = toLocalCurrencyString(
                                                    referencePrice),
                                                referencePrice > 0
                                            {
                                                Text("\(referencePriceFormatted) ")
                                                    .strikethrough()
                                                    .foregroundStyle(.tertiary)
                                            }

                                            if productDetails.duration == "week" {
                                                Text("then ")
                                            }

                                            Text(
                                                " " + productDetails.price + " "
                                                    + productDetails.priceDurationInfo
                                            )
                                            .foregroundStyle(.white)
                                        }.font(.subheadline)
                                    }
                                }
                                Spacer()
                                if productDetails.duration == "year" {
                                    VStack {
                                        Text(
                                            "SAVE \(calculatePercentageSaved(for: productDetails.duration))%"
                                        )
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                        .padding(8)
                                    }
                                    .background(Color.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                }

                                ZStack {
                                    Image(
                                        systemName: (selectedProductId == productDetails.productId)
                                            ? "circle.fill" : "circle"
                                    )
                                    .foregroundStyle(
                                        (selectedProductId == productDetails.productId)
                                            ? color : Color.primary.opacity(0.15))

                                    if selectedProductId == productDetails.productId {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(Color.white)
                                            .scaleEffect(0.7)
                                    }
                                }
                                .font(.title3.bold())

                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }
                        .background {
                            Color(.secondarySystemBackground)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        (selectedProductId == productDetails.productId)
                                            ? color : Color.primary.opacity(0.15), lineWidth: 1)
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(
                                        (selectedProductId == productDetails.productId)
                                            ? color.opacity(0.05) : Color.clear)
                            }
                        )
                    }
                    .buttonStyle(.plain)

                }

            }
            .opacity(isFetchingProducts ? 0 : 1)

            if productDetails.contains(where: { $0.hasFreeTrial }) {

                Toggle("Free trial enabled", isOn: isFreeTrialBinding)
                    .tint(.accent)
            }

            // Purchase Button Section
            VStack {

                ZStack(alignment: .center) {

                    // Progress indicator while purchasing
                    ProgressView()
                        .opacity(isPurchasing ? 1 : 0)

                    // Purchase button
                    Button {
                        if !isPurchasing {
                            purchaseSubscription(productId: self.selectedProductId)
                        }
                    } label: {
                        HStack {
                            Spacer()
                            HStack {
                                Text(callToActionText)
                                Image(systemName: "chevron.right")
                            }
                            Spacer()
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .font(.title3.bold())
                        .background(color)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .opacity(isPurchasing ? 0 : 1)
                }

                Text(subscriptionSubText)
                    .font(.caption)

            }
            .opacity(isFetchingProducts ? 0 : 1)
        }
        .id("view-\(isFetchingProducts)")
        .overlay {
            if isFetchingProducts {
                ProgressView()
            }
        }
    }

    @ViewBuilder
    var footerView: some View {
        VStack {
            HStack(spacing: 10) {
                // Restore purchases button
                Button("Restore") {
                    restorePurchases()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                        if !subscription.isSubscribed {
                            showNoneRestoredAlert = true
                        }
                    }
                }
                .alert("Restore Purchases", isPresented: $showNoneRestoredAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("No purchases restored")
                }
                .underline()
                .font(.footnote)

                // Terms and privacy button
                Button("Terms of Use & Privacy Policy") {
                    showTermsActionSheet = true
                }
                .underline()
                .font(.footnote)
                .confirmationDialog("View Terms & Conditions", isPresented: $showTermsActionSheet) {
                    Button("Terms of Use") {
                        if let url = URL(string: "https://whitebg.net/terms-of-service") {
                            UIApplication.shared.open(url)
                        }
                    }

                    Button("Privacy Policy") {
                        if let url = URL(string: "https://whitebg.net/privacy-policy") {
                            UIApplication.shared.open(url)
                        }
                    }

                    Button("Cancel", role: .cancel) {}
                }
            }
            .foregroundStyle(.gray)
            .font(.system(size: 15))
        }.padding(.bottom, 60)
    }

    // Actual StoreKit purchase functions
    func purchaseSubscription(productId: String) {
        guard !isPurchasing else { return }

        isPurchasing = true

        Task {
            do {
                // Request the product from the App Store
                let products = try await Product.products(for: [productId])

                guard let product = products.first else {
                    await MainActor.run {
                        isPurchasing = false
                        errorMessage = "Product not found"
                        showErrorAlert = true
                    }
                    print("Product not found: \(productId)")
                    return
                }

                // Purchase the product
                // Note: We're still handling the immediate result, but transactions will also
                // be captured by the Transaction.updates listener for redundancy
                let result = try await product.purchase()

                // Process the purchase result
                switch result {
                case .success(let verification):
                    // Verify the transaction
                    let transaction = try subscription.checkVerified(verification)

                    // Update the subscription status
                    await MainActor.run {
                        subscription.isSubscribed = true
                        isPurchasing = false
                    }

                    // Finish the transaction
                    await transaction.finish()

                case .userCancelled:
                    await MainActor.run {
                        isPurchasing = false
                        print("User cancelled the purchase")
                    }

                case .pending:
                    await MainActor.run {
                        isPurchasing = false
                        // Notify user about pending state
                        errorMessage = "Your purchase is pending approval"
                        showErrorAlert = true
                    }

                default:
                    await MainActor.run {
                        isPurchasing = false
                        errorMessage = "Unknown purchase result"
                        showErrorAlert = true
                    }
                }
            } catch {
                await MainActor.run {
                    isPurchasing = false
                    errorMessage = "Error: \(error.localizedDescription)"
                    showErrorAlert = true
                    print("Error purchasing product: \(error.localizedDescription)")
                }
            }
        }
    }

    func restorePurchases() {
        guard !isPurchasing else { return }

        isPurchasing = true

        Task {
            do {
                // Request the latest transaction status from the App Store
                try await AppStore.sync()

                // Update the subscription status based on current entitlements
                await subscription.updateCustomerProductStatus()

                await MainActor.run {
                    isPurchasing = false
                }
            } catch {
                await MainActor.run {
                    isPurchasing = false
                    print("Error restoring purchases: \(error.localizedDescription)")
                }
            }
        }
    }

    private func startShaking() {
        let totalDuration = 0.7  // Total duration of the shake animation
        let numberOfShakes = 3  // Total number of shakes
        let initialAngle: Double = 10  // Initial rotation angle

        withAnimation(.easeInOut(duration: totalDuration / 2)) {
            self.shakeZoom = 0.95
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration / 2) {
                withAnimation(.easeInOut(duration: totalDuration / 2)) {
                    self.shakeZoom = 0.9
                }
            }
        }

        for i in 0..<numberOfShakes {
            let delay = (totalDuration / Double(numberOfShakes)) * Double(i)
            let angle = initialAngle - (initialAngle / Double(numberOfShakes)) * Double(i)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(
                    Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2))
                ) {
                    self.shakeDegrees = angle
                }
                withAnimation(
                    Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2)).delay(
                        totalDuration / Double(numberOfShakes * 2))
                ) {
                    self.shakeDegrees = -angle
                }
            }
        }

        // Stop the shaking and reset to 0
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            withAnimation {
                self.shakeDegrees = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                startShaking()
            }
        }
    }

    func toLocalCurrencyString(_ value: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value))
    }

    struct PurchaseFeatureView: View {

        let title: String
        let icon: String
        let color: Color

        var body: some View {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    MyPurchaseView(isPresented: .constant(true))
        .environmentObject(Subscription())
        .environmentObject(LayoutManager())
        .preferredColorScheme(.dark)
}
