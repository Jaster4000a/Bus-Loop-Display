//
//  ViewController.swift
//  Bus Loop Sender
//
//  Created by Jason Cabrejos on 3/24/17.
//  Copyright © 2017 Jason Cabrejos. All rights reserved.
//

import UIKit
import CoreBluetooth


class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    var peripherals = Array<CBPeripheral>()
    
    let devName = "CHS Bus Loop"
    let servUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9E50E24DCCA9E")
    let txChar = CBUUID(string: "6E400002-B5A3-F393-E0A9E50E24DCCA9E")
    let rxChar = CBUUID(string: "6E400003-B5A3-F393-E0A9E50E24DCCA9E")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: [servUUID], options: nil)
        } else {
            print("Bluetooth not available.")
        }
    }
    
    
    
    func centralManager(central: CBCentralManager, didDiscoverperipheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary)
            .object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        if device?.contains(devName) == true{
            self.manager.stopScan()
            
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager.connect(peripheral, options: nil)
        }
        
        func centralManager2(central: CBCentralManager, didConnectperipheral peripheral: CBPeripheral){
            peripheral.discoverServices(nil)
        }
        func peripheral(peripheral: CBPeripheral,didDiscoverServices error: NSError?){
            for service in peripheral.services! {
                let thisService = service as CBService
                
                if service.uuid == txChar{
                    peripheral.discoverCharacteristics(nil, for:thisService)
                }
            }
        }
        peripherals.append(peripheral)
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var segment1: UISegmentedControl!
    @IBOutlet weak var segment2: UISegmentedControl!
    @IBOutlet weak var segment3: UISegmentedControl!
    @IBOutlet weak var segment4: UISegmentedControl!
    @IBOutlet weak var segment5: UISegmentedControl!
    @IBOutlet weak var segment6: UISegmentedControl!
    
    @IBAction func updateDecimal(_ sender: Any) {
        var LED1=""
        var LED2=""
        var LED3=""
        var LED4=""
        var LED5=""
        var LED6=""
        var combine=""
        //if segment 2 (off) is selected, then the code is 002 regardless of the textfield input
        if segment1.selectedSegmentIndex == 2{
            LED1 = "002"
        }else{
            LED1 = self.textField1.text! + "\(segment1.selectedSegmentIndex)"
        }
        
        if segment2.selectedSegmentIndex == 2{
            LED2 = "002"
        }else{
            LED2 = self.textField2.text! + "\(segment2.selectedSegmentIndex)"
        }
        
        if segment3.selectedSegmentIndex == 2{
            LED3 = "002"
        }else{
            LED3 = self.textField3.text! + "\(segment3.selectedSegmentIndex)"
        }
        
        if segment4.selectedSegmentIndex == 2{
            LED4 = "002"
        }else{
            LED4 = self.textField4.text! + "\(segment4.selectedSegmentIndex)"
        }
        
        if segment5.selectedSegmentIndex == 2{
            LED5 = "002"
        }else{
            LED5 = self.textField5.text! + "\(segment5.selectedSegmentIndex)"
        }
        
        if segment6.selectedSegmentIndex == 2{
            LED6 = "002"
        }else{
            LED6 = self.textField6.text! + "\(segment6.selectedSegmentIndex)"
        }
        //if single digits are entered, this adds a zero to the front
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
        peripheral.writeValue(data!, for: txCharacteristic!, type:CBCharacteristicWriteType.withoutResponse)
        peripheral.writeValue(data, for txChar: CBCharacteristic, writeType: CBCharacteristicWriteType)
        peripheral.writeValue(data, for: txChar)

    }
    
}


/*extension ViewController: UITableViewDataSource{
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
 
 let peripheral = peripherals[indexPath.row]
 cell.textLabel?.text = peripheral.name
 
 return cell
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
 return peripherals.count
 }
 }*/
