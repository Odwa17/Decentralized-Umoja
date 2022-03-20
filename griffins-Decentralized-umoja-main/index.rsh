'reach 0.1';
'use strict'

const Budget = {
    balance: UInt,
};
//We use it to send funds between participants
const TransferFunds = {
    allocateFunds: Fun([UInt], Null),
}


export const main = Reach.App(() => {
    //definition of contract participants
    const NatGov = Participant ('National_Government', {
       // ...Budget,
       // ...TransferFunds, //allocates funds to Local Municipality
       // recieveRequest: Fun([Bytes(128)], Null), //recieves request for budget from LocalMuni

    });
    const LocalMuni = Participant('Local_Municipality',{
        //...Budget,
       // ...TransferFunds, //used to pay for a service
        //getService: Fun([Bytes(128)], Null), //used to get information about a service from the supplier
        requestBudget: UInt,  //funds to request from the NatGov
        reasonForRequest: Bytes(128), //reason for questing funds from the NatGov
    });
   
    init();

    //Initiating the agreement betwen LM and NG
    LocalMuni.only(() => {
        const budgetReq = declassify(interact.requestBudget); //request funds from NatGov
        const budgetReason = declassify(interact.reasonForRequest); //brief reason for the requested funds
    });
    LocalMuni.publish(budgetReq,budgetReason);
    commit();

   // NatGov accepts the agreement and pay the requested funds
    NatGov.only(() => {
        /*const funds = declassify(interact.budgetReq); //get the funds from  the UI
       /* const transferfunds = declassify(interact.allocateFunds(funds));
        interact.recieveRequest(budgetReason);*/
    }); 
    NatGov.pay(budgetReq); //send the funds to the pot
    transfer(budgetReq).to(LocalMuni); //sending the agreed funds from the pot to LM account
    commit();


    exit();
});
