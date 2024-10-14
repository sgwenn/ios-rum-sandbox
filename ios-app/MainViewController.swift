//
//  MainViewController.swift
//  ios-app
//
//  Created by Gwen Sax on 14/10/2024.
//

import UIKit
import DatadogCore
import DatadogLogs
import DatadogRUM
import DatadogTrace
import DatadogCrashReporting

let logger = Logger.create(
    with: Logger.Configuration(
        service: "pomme",
        name: "log-dog",
        networkInfoEnabled: true,
        remoteLogThreshold: .info,
        consoleLogFormat: .shortWith(prefix: "[iOS App] ")
    )
)
let appID = "<app-id>"
let clientToken = "<client-token>"
let environment = "testing"
let tracer = Tracer.shared()
let rum = RUMMonitor.shared()

class MainViewController: UIViewController {
    @IBOutlet weak var logsButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var traceButton: UIButton!
    @IBOutlet weak var resourceButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var switchViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Datadog.initialize(
            with: Datadog.Configuration(
                clientToken: clientToken,
                env: environment,
                site: .us1
            ),
            trackingConsent: .granted
        )

        RUM.enable(
            with: RUM.Configuration(
                applicationID: appID,
                uiKitViewsPredicate: DefaultUIKitRUMViewsPredicate(),
                uiKitActionsPredicate: DefaultUIKitRUMActionsPredicate()
            )
        )
        Trace.enable(
            with: Trace.Configuration(
                networkInfoEnabled: true
            )
        )
        Logs.enable()
        Datadog.verbosityLevel = .debug
        
        CrashReporting.enable()

        // setting user info for session collection
        Datadog.setUserInfo(id: "abcde12345", name: "datadog", email: "puppy@example.com")
        
        // testing custom attributes
        rum.addAttribute(forKey: "Foo", value: "Bar")
        
    }

    @IBAction func sendLogs(_ sender: UIButton) {
        logger.notice("Sent notice, working fine")
//        logger.info("Sent info level log", attributes: ["context" : "application test"])
//        logger.warn("Sent warning level log")
        
        // UI feedback to check if function worked
        label.isHidden = false
        label.text = "Log Sent!"

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.label.isHidden = true
        }
    }
    
    @IBAction func sendTrace(_ sender: UIButton) {
        let span = tracer.startSpan(operationName: "something I measured here")
        span.finish()
        
        // UI feedback to check if function worked
        label.isHidden = false
        self.label.text = "Trace Sent!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.label.isHidden = true
        }
    }
    
    @IBAction func sendResource(_ sender: UIButton) {
        // rum start
        rum.startResource(
            resourceKey: "api",
            url: URL(string: "api")!
        )

// If you can you can call a resource here, like here is an API call
        rum.stopResource(
            resourceKey: "api",
            response: HTTPURLResponse(url: URL(string: "api")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: ["test" : "test"])!,
            size: 0
            )
                
        // UI feedback to check if function worked
        label.isHidden = false
        self.label.text = "Resource Sent!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.label.isHidden = true
        }
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        
        rum.addAction(
            type: .custom,
            name: (sender as? UIButton)?.currentTitle ?? "sendexample"
        )

        // UI feedback to check if function worked
        label.isHidden = false
        self.label.text = "Action Sent!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.label.isHidden = true
        }
    }
    @IBAction func backToMain(sender: UIStoryboardSegue) {
    }
    
    @IBAction func switchView(_ sender: UIButton) {
        rum.addTiming(name: "example_timing")
    }
    
}

