import Flutter
import UIKit
import GoogleMaps
import Firebase
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() 

    GMSServices.provideAPIKey("AIzaSyBUIGI-rbZxSBy7WaQhztUgkvhzpI8STpA")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
