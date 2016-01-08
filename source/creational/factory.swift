/*:
🏭 Factory Method
-----------------

The factory pattern is used to replace class constructors, abstracting the process of object generation so that the type of the object instantiated can be determined at run-time.

### Example
*/

protocol CloudStorage {
    
    var accountNumber : String { get }
    var password : String { get }
    
    func upload(path file: String)
    func fetch()
    
}

class WorkStorage : CloudStorage {
    
    var accountNumber : String = "wrk-1324652657"
    var password : String = "=alksjdfh*#$7bfjs8fhjsd"
    
    func upload(path file: String) {
        print("\(file) uploaded to account \(accountNumber)\n")
        print("Upload to Work Storage Complete\n")
    }
    
    
    func fetch() {
        print("Fetching work storage data...")
        
    }
    
}

class PersonalStorage : CloudStorage {
    
    var accountNumber : String = "prsnl-98766-bfds"
    var password : String = "=alksjdioasdf98eh8fhjsd"
    
    func upload(path file: String) {
        print("\(file) uploaded to account \(accountNumber)\n")
        print("Upload to Personal Storage Complete\n")
    }
    
    func fetch() {
        print("Fetching personal storage data...")
        
    }
    
}

class BackupStorage : CloudStorage {
    
    var accountNumber : String = "bkup-zsdf976fds"
    var password : String = "=al324513dioas-df9ddhjsd"
    
    func upload(path file: String) {
        print("\(file) uploaded to account \(accountNumber)\n")
        print("Upload to Backup Storage Complete\n")
    }
    
    
    func fetch() {
        print("Fetching backup storage data...")
        
    }
    
}

enum FileTypes : String {
    case Images = "png"
    case Videos = "mov"
    case Archives = "zip"
    case Docs = "pages"
}


class CloudFactory {
    class func accountForType(file: String) -> CloudStorage {
        
        let str = file.characters.split(".")
        let ext = String(str.last!)
        
        guard let fileType = FileTypes(rawValue: ext) else {
            return BackupStorage()
        }
        
        switch fileType {
        case .Images, .Videos :
            return BackupStorage()
        case .Archives :
            return PersonalStorage()
        case .Docs :
            return WorkStorage()
            
        }
    }
}


let filePath = [
    "path/to/file/IMG_0065.png",
    "path/to/file/myVideo.mov",
    "path/to/file/document.pages",
    "path/to/file/IMG_0067.png",
    "path/to/file/IMG_0068.png",
    "path/to/file/data.zip",
    "path/to/file/anotherVideo.mov",
    "path/to/file/data2.zip",
    "path/to/file/doc2.pages",
]



for file in filePath {
    
    CloudFactory.accountForType(file).upload(path: file)
}




