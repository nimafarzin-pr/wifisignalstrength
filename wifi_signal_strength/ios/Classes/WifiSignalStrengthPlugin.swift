import Flutter
import UIKit
import SystemConfiguration.CaptiveNetwork
import Foundation
import CoreLocation
import NetworkExtension

public class WifiSignalStrengthPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wifi_signal_strength", binaryMessenger: registrar.messenger())
        let instance = WifiSignalStrengthPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getWifiSignalStrength" {
            startLocationServices(result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func startLocationServices(result: @escaping FlutterResult) {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            fetchWiFiSignalStrength(result: result)
        } else {
            result(FlutterError(code: "UNAVAILABLE", message: "Location permission not granted", details: nil))
        }
    }

    private func fetchWiFiSignalStrength(result: @escaping FlutterResult) {
        if #available(iOS 14.0, *) {
            getWiFiSignalStrengthUsingNEHotspot(result: result)
        } else {
            if let wifiInfo = getWiFiSignalStrengthUsingCNCopy() {
                result(wifiInfo)
            } else {
                result(FlutterError(code: "UNAVAILABLE", message: "Could not fetch Wi-Fi signal strength123", details: nil))
            }
        }
    }

    private func getWiFiSignalStrengthUsingCNCopy() -> String? {
        guard let interface = CNCopySupportedInterfaces() as NSArray? else { return nil }
        guard let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interface[0] as! CFString) as NSDictionary? else { return nil }
        guard let signalStrength = unsafeInterfaceData["SSID"] as? String else { return nil }
        return signalStrength
    }

    @available(iOS 14.0, *)
    private func getWiFiSignalStrengthUsingNEHotspot(result: @escaping FlutterResult) {
        NEHotspotNetwork.fetchCurrent { network in
            if let ssid = network?.ssid {               
                 result(ssid)
            } else {
                result(FlutterError(code: "UNAVAILABLE", message: "Could not fetch Wi-Fi signal strength", details: nil))
            }
        }
    }

    // CLLocationManagerDelegate method
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Permissions granted, handle accordingly
        }
    }
}
