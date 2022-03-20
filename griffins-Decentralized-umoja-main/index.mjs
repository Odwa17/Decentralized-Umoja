import { loadStdlib } from '@reach-sh/stdlib';
import * as backend from './build/index.main.mjs';

const stdlib = loadStdlib(process.env);
const startingBalance = stdlib.parseCurrency(100);
const accNatGov= await stdlib.newTestAccount(startingBalance);
const accLocalMuni = await stdlib.newTestAccount(100);

const fmt = (x) => stdlib.formatCurrency(x, 4);
const getBalance = async (who) => fmt(await stdlib.balanceOf(who));
const beforeNatGov = await getBalance(accNatGov);
const beforeLocalMuni = await getBalance(accLocalMuni);

const ctcNatgov = accNatGov.contract(backend);
const ctcLocalMuni = accLocalMuni.contract(backend,ctcNatgov.getInfo());


await Promise.all([
    ctcNatgov.p.National_Government({
    }),

    ctcLocalMuni.p.Local_Municipality({ 
        requestBudget : stdlib.parseCurrency(10),
        reasonForRequest : 'I need that to buy Okuhle earphones',
    })

]);

const afterNatGov = await getBalance(accNatGov);
const afterLocalMuni = await getBalance(accLocalMuni);

console.log(`National_Government went from ${beforeNatGov} to ${afterNatGov}.`);
console.log(`Local_Municipality went from ${beforeLocalMuni} to ${afterLocalMuni}.`);

