'reach 0.1';

const Budget = {
    balance: UInt,
};
const TransferFunds ={
    allocateFunds: Fun([UInt], Null),
}
const RecieveFunds ={
    getFunds: Fun([],UInt),
}

export const main = Reach.App(() => {
    //definition of contract participants
    const NatGov= Participant ('National_Government', {
        ...Budget,
        ...TransferFunds,
    }); 
    const LocalMuni= Participant('Local_Municipality',{
        ...Budget,
        ...TransferFunds,
        ...RecieveFunds,
    });
    const Supplier= Participant ('Service_Provider',{
        ...RecieveFunds,
    });
    init();

    //actions of each participant
    NatGov.only(() => {
        const funds= declassify(interact.balance);
        const transferfunds= declassify(interact.allocateFunds(funds));
    });
    NatGov.publish(funds,transferfunds)
        .pay(funds);
    commit();

    LocalMuni.only(() => {
        //declassify(interact.getFunds());
        const Munifunds= declassify(interact.balance);
        const PaySupplier= declassify(interact.allocateFunds(Munifunds));
    });
    LocalMuni.publish(Munifunds,PaySupplier)
        .pay(Munifunds);   
    commit();
});