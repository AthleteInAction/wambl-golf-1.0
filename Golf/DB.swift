class DB {
    
    // LOGIN
    // ========================================================================
    // ========================================================================
    class func login(username _username: String, password _password: String, completion: (s: Bool, error: NSError!) -> Void) {
        
        PFUser.logInWithUsernameInBackground(_username, password: _password) { (user: PFUser!, error: NSError!) -> Void in
            
            if !(error != nil) {
                
                
                
            } else {
                
                var code = error.userInfo?["code"] as Int
                
                Error.report(user: nil, error: error, alert: true)
                
            }
            
            completion(s: !(error != nil), error: error)
            
        }
        
    }
    // ========================================================================
    // ========================================================================
    
    // SIGNUP
    // ========================================================================
    // ========================================================================
    class func signup(user _user: PFUser, completion: (s: Bool, e: NSError!) -> Void){
        
        _user.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            
            if !success {
                
                Error.report(user: nil, error: error, alert: true)
                
            }
            
            completion(s: success, e: error)
            
        }
        
    }
    // ========================================================================
    // ========================================================================
    
}