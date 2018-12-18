import Foundation
import Gloss
class User:Decodable {
    var id:String?
    var fullName:String?
    var email:String?
    var password:String?
    var contactNumber:String?
    var state:Int?
    var deviceID:String?
    var fullAddress:String?
    required init?(json: JSON) {        
        self.id = ("_id" <~~ json)!
        self.fullName = ("full_name" <~~ json)!
        self.email = ("email" <~~ json)!
        self.fullAddress = ("full_address" <~~ json)!
        self.password = ("password" <~~ json)!
        self.contactNumber = ("contact_number" <~~ json)!
        self.state = ("state" <~~ json)!
        self.deviceID = ("device_id" <~~ json)!
    }
    func toJSON() -> JSON? {
        return jsonify([
            "_id" ~~> self.id,
            "full_name" ~~> self.fullName,
            "email" ~~> self.email,
            "password" ~~> self.password,
            "contact_number" ~~> self.contactNumber,
            "state" ~~> self.state,
            "device_id" ~~> self.deviceID,
            "full_address" ~~> self.fullAddress
            ])
    }
}
