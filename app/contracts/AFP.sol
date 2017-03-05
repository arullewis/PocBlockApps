contract AFP {

    struct Approver {
        bool completed;
        bool isApproved;
        address delegate;
        bytes32 email;
    }
    struct AFPHeader {
        bytes32 activityName;
        uint budget;
        bool isCompleted;
        address[] approverList;
    }

    address public chairperson;
    mapping(address => Approver) public approvers;
    AFPHeader public afpheader;

    // Create a new AFP and set approvers.
    function AFP(bytes32 name, uint bud, address[] lapp, bytes32[] emails) {
        chairperson = msg.sender;
        approvers[chairperson].completed = true;
        afpheader.activityName = name;
        afpheader.budget = bud;
        afpheader.approverList = lapp;
        giveRightToApprove(lapp, emails);
    }

    // Give $(voter) the right to vote on this ballot.
    // May only be called by $(chairperson).
    function giveRightToApprove(address[] lapps, bytes32[] emails) {
        
        if(msg.sender == chairperson)
        {
        for (uint i = 0; i < lapps.length; i++) {
            
         approvers[lapps[i]].completed = false;
         approvers[lapps[i]].delegate = lapps[i];
         approvers[lapps[i]].email = emails[i];
         
        } 
        }else
        {
            throw;
        }
        
    }
    
    
    // Give a single vote to proposal $(proposal).
    function approve(bool isapp) {
        Approver sender = approvers[msg.sender];
        if (sender.completed || afpheader.isCompleted) return;
        sender.completed = true;
        sender.isApproved = isapp;
        
        uint isFinished = 1;
        
        for (uint i = 0; i < afpheader.approverList.length; i++) {
            
            uint temp = 0;
            if( approvers[afpheader.approverList[i]].completed) temp = 1 ;
             isFinished = isFinished * temp ; 
            
        }
        if(isFinished == 1) afpheader.isCompleted = true;
        
    }
    
    function  whoHasNotApproved() returns (bytes32[] )
    {
        bytes32[] emails;
        
         for (uint i = 0; i < afpheader.approverList.length; i++) {
            
            if(!approvers[afpheader.approverList[i]].completed) 
            emails.push(approvers[afpheader.approverList[i]].email) ;
            
            
        }
        return(emails);
        
    }
    
    

    
}
