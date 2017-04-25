//
//  ViewController.swift
//  Bus Loop App
//
//  Created by Jason Cabrejos on 4/10/17.
//  Copyright © 2017 Jason Cabrejos. All rights reserved.
//

import UIKit
import CoreBluetooth


    class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
        
        var manager:CBCentralManager!
        var peripheral:CBPeripheral!
        var peripherals = Array<CBPeripheral>()
        
        let devName = "CHS Bus Loop"
        let servUUID = CBUUID(string: "6E400001-b5A3-F393-E0A9-E50E24DCCA9E")
        let txChar = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
        let rxChar = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
        var Devservice: CBService?
        var txCharacteristic: CBCharacteristic?
        var rxCharacteristic: CBCharacteristic?
        let writeType: CBCharacteristicWriteType = .withoutResponse
        
        override func viewDidLoad() {
            super.viewDidLoad()
            textLabel.text="CHS We Are One"
            manager = CBCentralManager(delegate: self, queue: nil)
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
            view.addGestureRecognizer(tap)
            // Do any additional setup after loading the view, typically from a nib.
        }
        //Calls this function when tap is recognised
        func dismissKeyboard(){
            //Causes the view (or one of its embedded textfields) to resign the first responder status
            view.endEditing(true)
        }

        
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            if central.state == CBManagerState.poweredOn {
               // central.scanForPeripherals(withServices: [servUUID], options: nil)
                central.scanForPeripherals(withServices: nil, options: nil)
                NSLog("SCANNING")
            } else {
                NSLog("Bluetooth not available.")
            }
        }
        
        
        
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
            let device = (advertisementData as NSDictionary)
                .object(forKey: CBAdvertisementDataLocalNameKey)
                as? NSString
            
            
            if (device?.contains(devName) == true){
                self.manager.stopScan()
                self.peripheral = peripheral
                self.peripheral.delegate = self
                
                manager.connect(peripheral, options: nil)
            }
        }
        
            func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
                peripheral.discoverServices(nil)
            }
            
            func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
                for service in peripheral.services! {
                    let thisService = service as CBService
                    if thisService.uuid == servUUID{
                        Devservice = thisService
                        print(service.uuid)
                        peripheral.discoverCharacteristics(nil, for:thisService)
                    }
                }
            }
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor Devservice: CBService, error: Error?){
                for characteristic in Devservice.characteristics! {
                    let thisCharacteristic = characteristic as CBCharacteristic
                    
                    if thisCharacteristic.uuid == rxChar {
                        rxCharacteristic = thisCharacteristic
                        self.peripheral.setNotifyValue(
                            true, 
                            for: thisCharacteristic
                        )
                    }
                    if thisCharacteristic.uuid == txChar{
                        txCharacteristic = thisCharacteristic
                    }
                }
            }
            
            
            
            
    //        peripherals.append(peripheral)
            //tableView.reloadData()
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        @IBOutlet weak var textField1: UITextField!
        @IBOutlet weak var textField2: UITextField!
        @IBOutlet weak var textField3: UITextField!
        @IBOutlet weak var textField4: UITextField!
        @IBOutlet weak var textField5: UITextField!
        @IBOutlet weak var textField6: UITextField!
        @IBOutlet weak var direct1: UISegmentedControl!
        @IBOutlet weak var direct2: UISegmentedControl!
        @IBOutlet weak var direct3: UISegmentedControl!
        @IBOutlet weak var direct4: UISegmentedControl!
        @IBOutlet weak var direct5: UISegmentedControl!
        @IBOutlet weak var direct6: UISegmentedControl!
        @IBOutlet weak var textLabel: UILabel!
        
        @IBAction func UpdateDecimal(_ sender: Any) {
            var LED1=" "
            var LED2=" "
            var LED3=" "
            var LED4=" "
            var LED5=" "
            var LED6=" "
            var combine=" "
            
            if direct1.selectedSegmentIndex == 2{
                LED1 = "002"
            }else{
                LED1 = self.textField1.text! + "\(direct1.selectedSegmentIndex)"
            }
            
            if direct2.selectedSegmentIndex == 2{
                LED2 = "002"
            }else{
                LED2 = self.textField2.text! + "\(direct2.selectedSegmentIndex)"
            }
            
            if direct3.selectedSegmentIndex == 2{
                LED3 = "002"
            }else{
                LED3 = self.textField3.text! + "\(direct3.selectedSegmentIndex)"
            }
            
            if direct4.selectedSegmentIndex == 2{
                LED4 = "002"
            }else{
                LED4 = self.textField4.text! + "\(direct4.selectedSegmentIndex)"
            }
            
            if direct5.selectedSegmentIndex == 2{
                LED5 = "002"
            }else{
                LED5 = self.textField5.text! + "\(direct5.selectedSegmentIndex)"
            }
            
            if direct6.selectedSegmentIndex == 2{
                LED6 = "002"
            }else{
                LED6 = self.textField6.text! + "\(direct6.selectedSegmentIndex)"
            }
            
            if LED1.characters.count == 2{
                LED1="0" + LED1
            }
            if LED2.characters.count == 2{
                LED2="0" + LED2
            }
            if LED3.characters.count == 2 {
                LED3="0" + LED3
            }
            if LED4.characters.count == 2{
                LED4="0" + LED4
            }
            if LED5.characters.count == 2{
                LED5="0" + LED5
            }
            if LED6.characters.count == 2{
                LED6="0" + LED6
            }
            
            if LED1.characters.count + LED2.characters.count + LED3.characters.count + LED4.characters.count + LED5.characters.count + LED6.characters.count != 18{
                textLabel.text = "All MUST have 2 digits"
            }else{
                combine = LED1 + LED2 + LED3 + LED4 + LED5 + LED6
                textLabel.text = combine
            }
            let data = combine.data(using: String.Encoding.utf8)
            peripheral.writeValue(data!, for: txCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
        }

}



