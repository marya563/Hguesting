//

//  FaceIdViewController.swift

//  EasyKitchen

//

//  Created by Apple Esprit on 5/5/2023.

//



import UIKit

import LocalAuthentication



class FaceIdViewController: UIViewController {

    let defaults = UserDefaults.standard

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)



        // Hide the back button

        navigationItem.hidesBackButton = true

    }

    override func viewDidLoad() {

        super.viewDidLoad()

        

        let token = defaults.object(forKey: "token") as? String



        

            

        let context = LAContext()

        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { (success, error) in

                if success {

                    print("Authentication succeeded")

                        

                } else {

                    print("Authentication failed")


                    

                }

            }

        } else {

            print("Biometric authentication is not available")

            // Add your logic to handle biometric authentication not available

        }

        

    }

        

    

    @IBAction func faceIdTapped(_ sender: Any) {

        let context = LAContext()

        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { (success, error) in

                if success {

                    print("Authentication succeeded")

                    

                } else {

                    print("Authentication failed")


                    

                }

            }

        } else {

            print("Biometric authentication is not available")

            // Add your logic to handle biometric authentication not available

        }

    }

}
