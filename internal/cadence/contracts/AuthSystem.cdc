// Welcome to the AuthSystem contract
//
// This contract is a service that maps a user's on-chain address
// to their DiscordID. 
//
// A user cannot configure their own EmeraldID. It must be done 
// by someone who has access to the Administrator resource.
//
// A user can only ever have 1 address mapped to 1 DiscordID, and
// 1 DiscordID mapped to 1 address. This means you cannot configure
// multiple addresses to your DiscordID, and you cannot configure
// multiple DiscordIDs to your address. 1-1.

pub contract AuthSystem {
    /***********************************************/
    /******************** PATHS ********************/
    /***********************************************/

    // Contract Specific Paths
    pub let AdministratorStoragePath: StoragePath
    pub let AdministratorPrivatePath: PrivatePath

    // User Profile Paths
    pub let UserProfileStoragePath: StoragePath
    pub let UserProfilePublicPath: PublicPath
    pub let UserProfilePrivatePath: PrivatePath

    // Auth System Paths
    pub let AuthSystemCollectionStoragePath: StoragePath
    pub let AuthSystemsCollectionPublicPath: PublicPath
    pub let AuthSystemAdminCollectionStoragePath: StoragePath
    pub let AuthSystemAdminCollectionPrivatePath: PrivatePath

    /************************************************/
    /******************** EVENTS ********************/
    /************************************************/

    // Contract Specefic Events
    pub event ContractInitialized()
    pub event AdministratorCreated(address: Address)
    pub event AdministratorDestroyed(address: Address)

    // User Profile Events
    pub event UserProfileCreated(id: UInt64, address: Address, displayName: String, avatar: String)
    pub event UserProfileDestroyed(id: UInt64, address: Address)

    // Auth System Events
    pub event AuthSystemCreated(id: UInt64, name: String, address: Address, description: String, image: String, url: String)
    pub event AuthSystemDestroyed(id: UInt64, name: String, address: Address)
    pub event AuthSystemAdminCreated(authSystemId: UInt64, profileId: UInt64, authSystemAddrs: Address, profileAddress: Address)
    pub event AuthSystemAdminDestroyed(authSystemId: UInt64, profileId: UInt64, authSystemAddrs: Address, profileAddress: Address)

    /***********************************************/
    /******************** STATE ********************/
    /***********************************************/

    // The total amount of User Profiles that have ever been
    // created (does not go down when a User Profile is destroyed)
    pub var totalUserProfiles: UInt64

    // The total amount of Auth Systems that have ever been
    // created (does not go down when an Auth System is destroyed)
    pub var totalAuthSystems: UInt64

    // Map of user profiles to their Flow Account
    access(account) var profiles: {Address: ProfileIdentifier}

    /***********************************************/
    /**************** FUNCTIONALITY ****************/
    /***********************************************/


    // A helpful wrapper to contain an address, 
    // the id of a User Profile, and its serial
    pub struct ProfileIdentifier {
        pub let id: UInt64
        pub let address: Address
        pub let serial: UInt64

        init(_id: UInt64, _address: Address, _serial: UInt64) {
            self.id = _id
            self.address = _address
            self.serial = _serial
        }
    }


    //
    // User Profile
    //
    pub resource UserProfile {
        // Profile Identifiers
        pub let id: UInt64
        pub let serial: UInt64
        pub let createdAt: UFix64

        // User Profile Information
        pub var displayName: String
        pub var firstName: String
        pub var lastName: String
        pub var description: String
        pub var gender: String
        pub var avatar: String

        /***************** Setters for the Profile Owner *****************/
        pub fun updateDisplayName(_displayName: String) {
            self.displayName = _displayName
        }

        pub fun updateFirstName(_firstName: String) {
            self.firstName = _firstName
        }

        pub fun updateLastName(_lastName: String) {
            self.lastName = _lastName
        }

        pub fun updateDescription(_description: String) {
            self.description = _description
        }

        pub fun updateAvatar(_avatar: String) {
            self.avatar = _avatar
        }

        init (_serial: UInt64, _displayName: String, _firstName: String, _lastName: String, _description: String, _avatar: String, _gender: String) {
            self.id = self.uuid
            self.serial = _serial
            self.createdAt = getCurrentBlock().timestamp
            self.displayName = _displayName
            self.firstName = _firstName
            self.lastName = _lastName
            self.description = _description
            self.gender = _gender
            self.avatar = _avatar
        }

        destroy() {
            // TODO: Create EMIT event
        }
    }

    init() {
        self.totalUserProfiles = 0
        self.totalAuthSystems = 0
        self.profiles = {}

        emit ContractInitialized()

        self.AdministratorStoragePath = /storage/AuthSystemGlobalAdministrator
        self.AdministratorPrivatePath = /private/AuthSystemGlobalAdministrator
        self.UserProfileStoragePath = /storage/AuthSystemUserProfile
        self.UserProfilePrivatePath = /private/AuthSystemUserProfile
        self.UserProfilePublicPath = /public/AuthSystemUserProfile
        self.AuthSystemCollectionStoragePath = /storage/AuthSystemCollection
        self.AuthSystemsCollectionPublicPath = /public/AuthSystemCollection
        self.AuthSystemAdminCollectionStoragePath = /storage/AuthSystemAdminCollection
        self.AuthSystemAdminCollectionPrivatePath = /private/AuthSystemAdminCollection
    }
}