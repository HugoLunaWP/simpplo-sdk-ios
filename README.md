# SimpploSDK

A fast checkout that integrates your company to the payments and fraud ecosystem.
‍
Checkout + Routing + Reconciliations + Alternative Payment Methods

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

Once you have your Swift package set up, adding SimpploSDK as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/HugoLunaWP/simpplo-sdk-ios", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

SimpploSDK minimum required version is iOS 13.0

First, you'll need to get your Simpplo app ID and iOS API key. Then initialize Simpplo by importing Simpplo and adding the following to your application delegate:

```swift

import Foundation
import SimpploSdk

class SessionManager: ObservableObject {

    @Published var customerSession: String = ""
    @Published  var simpplo = Simpplo()

}

import SwiftUI
import SimpploSdk

struct ContentView: View {

   @StateObject var sessionManager = SessionManager()

  var body: some View {
    Text("Example Simmplo")
       .padding()
       .onAppear{
            initializeSDK()
        }
  }

    /**
     * Init SDK
     */
    private func initializeSDK(){

        let config = SimpploConfig(cardFlow: CardFormTypeSimmplo.oneStep, saveCardEnabled: true)//.oneStep card form and disables save card checkbox.

        sessionManager.simpplo.initializeSdk(apiKey: "", secretKey: "",config: config, sandbox: true)

    }


}
```

SimpploConfig:

```swift

final class SimpploConfig {
    let cardFormType: CardFormType // This is optional, .oneStep by default, this is to choose Payment and Enrollment Card flow.
    let saveCardEnabled: Bool // This is to choose if show save card checkbox on cards flows. It is false by default
}
```

## Functions

Steps to work with sdk

- 1.- Initialize SDK
- 2.- Create or set Customer Id
- 3.- Create Customer Session
- 4.- List Payment Methods (Optional)
- 5.- Register Payment Method with type of payment available in List Payments Methods (Use as default 'CARD')
- 6.- Launch UI to add new payment method

### Initialize

```swift

let config = SimpploConfig(cardFlow: CardFormTypeSimmplo.oneStep, saveCardEnabled: true)//.oneStep card form and disables save card checkbox.

simpplo.initializeSdk(apiKey: "", secretKey: "",config: config, sandbox: true)

```

### Create customer

```swift
let client = CreateClientRequest(
          merchant_customer_id: "",//(MÁX 255; MÍN 1).
          first_name: "", //(MÁX 255; MÍN 1)
          last_name: "", //(MÁX 255; MÍN 1)
          gender: "", //Options: [M, F, NB]
          date_of_birth: "", //Format: AAAA-MM-DD
          email: "", //MÁX 255; MÍN 3
          nationality: "", // ISO 3166-1 List: [AR, BO, BR, CL, CO, CR, CE, SV, GT, HN, MX, NI, PA, PY, PE, US, UY]
          country: ""// ISO 3166-1 List: [AR, BO, BR, CL, CO, CR, CE, SV, GT, HN, MX, NI, PA, PY, PE, US, UY]
          )

sessionManager.simpplo.createClient(createClient: client) { createClientResponse, errorResponse in
            print("Create Client")
            if(errorResponse == nil){
                //Set Client Info
            }

        }

```

### Create customer session

```swift
let accountId = ""//Your account Id
let customerSessionRequest: CustomerSessionRequest = CustomerSessionRequest(
  account_id: accountId,
  country: "", // ISO 3166-1 List: [AR, BO, BR, CL, CO, CR, CE, SV, GT, HN, MX, NI, PA, PY, PE, US, UY]
  customer_id: "", //Customer id generated in step 2
  callback_url: ""//Callback url
  )
```

### List Payment Methods

```swift
sessionManager.simpplo.getPaymentsMethods(customerSession: customerSession) { paymentsMethods, errorResponse in

            if(errorResponse == nil){
                print("Size payments methods")
                print(paymentsMethods?.payment_methods.count ?? 0)
            }

        }
```

### Register Payment Method

```swift

let registerPaymentMethodRequest = RegisterPaymentMethodRequest(
          account_id: accountId, //Your account Id
          payment_method_type: paymentMethodType, //Payment Method available
          country: country// ISO 3166-1 List: [AR, BO, BR, CL, CO, CR, CE, SV, GT, HN, MX, NI, PA, PY, PE, US, UY]
)

 let idemptencyKey = customerSession

 sessionManager.simpplo.registerPaymentMethod(idempotencyKey: idemptencyKey, customerSession: customerSession, registerPaymentMethodRequest: registerPaymentMethodRequest) { registerPaymentMethodRequest, errorResponse in

            if(errorResponse == nil){
                //Launch UI
            }


        }


```

### Enroll a new payment method / Launch UI to add new payment method

To display a view controller with the flow to enroll a new payment method, call the following method:

```swift
protocol SimpploDelegate: AnyObject {

    func simpploResult(_ result: Simpplo.Result)
}

//Main View
struct ContentView: View {

@State var isPresented = false
@StateObject var sessionManager = SessionManager()

var body: some View {
        NavigationView {
            VStack {

                Text("Example Simmplo")
                    .padding()
                Button(action: {
                     isPresented.toggle()
                }, label: {
                    Text("AGREGAR MÉTODO DE PAGO")
                })


                NavigationLink(isActive: $isPresented) {
                    MyView( countryCode: "MX", language: "ES", showEnrollmentStatus: true)
                        .environmentObject(sessionManager)
                } label: {
                    EmptyView()
                }


            }
        }
        .onAppear{

            initializeSDK()
        }
    }

}

import Foundation
import SwiftUI
import UIKit
import SimpploSdk

//Structure for wrapping UIViewController
struct MyView: UIViewControllerRepresentable {

    var countryCode = ""
    var language = ""
    var showEnrollmentStatus = true
    @EnvironmentObject var sessionManager: SessionManager


    func makeUIViewController(context: Context) -> UIViewController {
        let vc = MyViewController()
        let nv = UINavigationController(rootViewController: vc)
        vc.customerSession = self.sessionManager.customerSession
        vc.countryCode = self.countryCode
        vc.simpplo = self.sessionManager.simpplo
        vc.showEnrollmentStatus = self.showEnrollmentStatus

        return nv
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

import Foundation
import UIKit
import SimpploSdk

class MyViewController: UIViewController, SimpploDelegate {

    var customerSession: String = ""

    var countryCode: String = ""

    var language: String = "ES"

    var simpplo: Simpplo? = nil
    var showEnrollmentStatus: Bool = true


    func simpploResult(_ result: SimpploResult) {
        print("Result")
        print(result)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        simpplo!.launchRegisterNewPaymentMethod(customerSession: self.customerSession, country: self.countryCode, language: self.language, navigationController: self.navigationController!, delegate: self, showEnrollmentStatus: self.showEnrollmentStatus)

    }
}

```
