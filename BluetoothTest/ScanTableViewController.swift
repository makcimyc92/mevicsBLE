import CoreBluetooth
import UIKit

class ScanTableViewController: UITableViewController,CBCentralManagerDelegate {
    
    var peripherals:[CBPeripheral] = []
    var manager: CBCentralManager!
//    var parentView:MainViewController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager.init(delegate: self, queue: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scanBLEDevice()
    }
    func scanBLEDevice(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) {
            self.stopScanForBLEDevice()
        }
        
    }
    func stopScanForBLEDevice(){
        manager.stopScan()
        print("scan stopped")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peripherals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scanTableCell", for: indexPath)
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = peripherals[indexPath.row]
        manager.connect(peripheral, options: nil)
    }
    
    //CBCentralMaganerDelegate code
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (!peripherals.contains(peripheral)){
            peripherals.append(peripheral)
        }
        self.tableView.reloadData()
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
        switch central.state {
        case .poweredOn:
            manager.scanForPeripherals(withServices: nil, options: nil)
        default:
            break
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to "+peripheral.name!)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }

}
